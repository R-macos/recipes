## this script generates build/Makefile
## which is used to build libraries according to the recipes

## FIXME: this has hardcoded make -j12

default.prefix <- "usr/local"

root <- getwd()

f <- Sys.glob("recipes/*")
exclude <- grep("(\\.patch|~)$", f)
if (length(exclude)) f <- f[-exclude]

binary <- Sys.getenv("BINARY")
binary <- ! suppressWarnings((is.null(binary) || !isTRUE(as.logical(as.integer(binary)))))
binary.url <- Sys.getenv("BINARY_URL")
if (length(binary.url) && nchar(binary.url) < 1) binary.url <- NULL

noinstall <- if (is.null(Sys.getenv("NOINSTALL")) || !nzchar(Sys.getenv("NOINSTALL"))) "" else "#"

pkgs <- list()

bin <- file.path(root, "bin")

prefix <- Sys.getenv("PREFIX")
if (!length(prefix) || !nzchar(prefix)) prefix <- default.prefix
## strip any leading / - it has to be a relative path and no double //
prefix <- gsub("/+", "/", gsub("^/+", "", prefix))
## for tar --strip
ndir <- length(strsplit(prefix, "/", TRUE)[[1]])

sudo <- "sudo "
if (nzchar(Sys.getenv("NOSUDO"))) sudo <- ""

for (fn in f) {
    d <- read.dcf(fn)
    if (dim(d)[1] > 1L) {
        warning("File '", fn,"' has more than one section, using only the first one")
	d <- d[1,,drop=F]
    }
    db <- d[1,]
    d <- as.list(db)
    ver <- d$Version
    ## replace ${prefix} with the prefix
    d <- lapply(d, function(o) gsub("${prefix}", prefix, o, fixed=TRUE))
    ## replace ${ver} with the Version
    if (!is.null(ver)) d <- lapply(d, function(o) gsub("${ver}", ver, o, fixed=TRUE))
    src <- d$Source.URL
    pkg <- d$Package
    dep <- d$Depends
    dep <- if (length(dep) && any(nzchar(dep))) tools:::.get_requires_with_version_from_package_db(db, "Depends") else list()
    if (is.null(ver) && is.null(src)) { ## virtual
        pkgs[[pkg]] <- list(pkg=pkg, dep=dep, d=d)
        next
    }
    nver <- if (length(grep("[a-zA-Z]$", ver))) {
        suf <- substr(ver, nchar(ver), nchar(ver))
	mver <- substr(ver, 1, nchar(ver) - 1)
        m <- match(suf, letters)
	if (is.na(m)) m <- match(suf, LETTERS)
	nver <- package_version(paste(mver, m, sep='-'))
    } else package_version(ver)
    patch <- file.path(root, paste0(fn, ".patch"))
    if (!file.exists(patch)) patch <- c()
    pkgs[[pkg]] <- list(pkg=pkg, ver=ver, nver=nver, dep=dep, src=src, d=d, patch=patch)
}

ok <- TRUE

for (pkg in pkgs) {
    if (length(pkg$dep)) {
       for (cond in pkg$dep) if (!is.null(cond$name)) {
           if (is.null(pkgs[[cond$name]])) {
	       message("ERROR: ",pkg," requires ",cond$name," for which we have no recipe")
	       ok <- FALSE
           } else if (!is.null(cond$op)) {
               if (cond$op != ">=") {
                   message("ERROR: ",pkg," uses condition ",cond$name," ",cond$op, " ", as.character(cond$version), ", but we only supprot >= operators at this point")
                   ok <- FALSE
               } else {
                   if (pkgs[[cond$name]]$nver < cond$version) {
                        message("ERROR: ", pkg, "requires ",cond$name," ",cond$op, " ", as.character(cond$version), ", but ", cond$name, " is only available in ", pkgs[[cond$name]]$ver)
			ok <- FALSE
                   }
               }
           }
       }
    }
    if (!ok) stop("=== bailing out, dependencies not met ===")
}

os <- tolower(system("uname", int=T))
arch <- system("uname -m", int=T)
os.ver <- system("uname -r", int=T)
os.maj <- paste(os,gsub("\\..*","",os.ver),sep=".")

## auto-detect the binaries to pull from mac.R-project.org
if (binary && is.null(binary.url)) {
    if (!isTRUE(os == "darwin"))
        stop("BINARY_URL must be set for anything other than macOS")
    if (isTRUE(arch == "arm64")) {
        os.maj <-  "darwin.20"
        binary.url <- "https://mac.r-project.org/libs-arm64"
    } else {
        os.maj <- "darwin.17"
        binary.url <- "https://mac.r-project.org/libs-4"
    }
}

## default flags
cfgflags <- "--with-pic --disable-shared --enable-static"

cfg <- function(d) {
    ## set the default cfgflags unless Configure.script is set
    ## in which case we can't assume it is autoconf-based
    f <- if (length(d$Configure.script) || length(d$`Build-system`)) character() else cfgflags
    if (!is.null(d[["Configure"]])) f <- c(f, d[["Configure"]])
    if (!is.null(d[[paste0("Configure.",os)]])) f <- c(f, d[[paste0("Configure.",os)]])
    if (!is.null(d[[paste0("Configure.",os.maj)]])) f <- c(f, d[[paste0("Configure.",os.maj)]])
    if (!is.null(d[[paste0("Configure.",arch)]])) f <- c(f, d[[paste0("Configure.",arch)]])
    if (!is.null(d[[paste0("Configure.",os,".",arch)]])) f <- c(f, d[[paste0("Configure.",os,".",arch)]])
    if (!is.null(d[[paste0("Configure.",os.maj,".",arch)]])) f <- c(f, d[[paste0("Configure.",os.maj,".",arch)]])

    ## this is not completely fool-proof, but we try to accept --prefix overrides and not step on them
    if (!(length(d$Configure.script) || length(grep("^--prefix=", f)) || length(grep(" --prefix=", f))))
       f <- c(paste0("--prefix=/", prefix), f)

    paste(f, collapse=" ")
}

tryCatch(system("mkdir -p build/src 2>/dev/null"), error=function(e) NULL)
sink("build/Makefile")

TAR <- Sys.getenv("TAR")
if (!nzchar(TAR)) TAR <- "tar"
cat("TAR='", TAR, "'\n", sep='')
cat("PREFIX='", prefix, "'\n\n", sep='')

dep.targets <- function(dep, sep=' ')
   paste(sapply(dep, function(o) {
      dp <- pkgs[[o$name]]
      if (is.null(dp$ver)) dp$pkg else paste(dp$pkg, dp$ver, sep='-')
   }), collapse=sep)

for (pkg in pkgs) {
    if (is.null(pkg$ver)) { ## virtual
        cat(pkg$pkg,": ",dep.targets(pkg$dep),"\n\ttouch '$@'\n", sep='')
        next
    }

    pv <- paste0(pkg$pkg,"-",pkg$ver)
    bsys <- if (length(pkg$d$`Build-system`)) pkg$d$`Build-system` else ""
    if (nzchar(bsys) && !file.exists(bsys <- file.path(root, "scripts", paste0("configure.", bsys)))) stop("I can't find driver for the builds system ", bsys)
    dist <- if (length(pkg$d$Distribution.files)) pkg$d$Distribution.files else prefix
    srcdir <- if (length(pkg$d$Configure.subdir)) paste0("/",pkg$d$Configure.subdir[1L]) else ""
    cfg.scr <- if (length(pkg$d$Configure.script)) pkg$d$Configure.script else "configure"
    cfg.proc <- if (length(pkg$d$Configure.driver)) pkg$d$Configure.driver else ""
    cfg.chmod <- if (length(pkg$d$Configure.chmod)) pkg$d$Configure.chmod else ""
    mkinst <- if (length(pkg$d$Install)) pkg$d$Install else "make install"
    tar <- basename(pkg$src)
    if (!binary) {
        if (length(grep("in-sources", pkg$d$Special))) { ## requires in-sources install
            if (nzchar(cfg.chmod)) cfg.chmod <- paste("chmod", cfg.chmod, shQuote(cfg.scr), "&& ")
            cat(pv,"-dst: src/",pv," ",dep.targets(pkg$dep),"\n\trm -rf ",pv,"-obj $@ && rsync -a src/",pv,srcdir,"/ ",pv,"-obj/ && cd ",pv,"-obj && ",cfg.chmod,"PREFIX=", prefix, " ",cfg.proc," ./",cfg.scr," ",cfg(pkg$d)," && PREFIX=", prefix," make -j12 && PREFIX=", prefix, " ", mkinst, " DESTDIR=",root,"/build/",pv,"-dst\n\n", sep='')
        } else {
            if (nzchar(cfg.chmod)) cfg.chmod <- paste("chmod", cfg.chmod, shQuote(paste0("../src/",pv,srcdir,"/",cfg.scr)), "&& ")
            cat(pv,"-dst: src/",pv," ",dep.targets(pkg$dep),"\n\trm -rf ",pv,"-obj $@ && mkdir ",pv,"-obj && cd ",pv,"-obj && ", cfg.chmod,"PREFIX=", prefix, " ", cfg.proc," ../src/",pv,srcdir,"/",cfg.scr," ",cfg(pkg$d)," && PREFIX=", prefix, " make -j12 && PREFIX=", prefix, " ", mkinst, " DESTDIR=",root,"/build/",pv,"-dst\n\n", sep='')
        }
        do.patch <- if (length(pkg$patch)) paste("&& patch -p1 <", shQuote(pkg$patch)) else ""
        if (nzchar(bsys)) do.patch <- paste0(do.patch, " && cp ", shQuote(bsys), " configure")
        cat("src/",pv,": src/",tar,"\n\tmkdir -p src/",pv," && (cd src/",pv," && $(TAR) fxj ../",tar,"&& shopt -s dotglob && mv */* . && shopt -u dotglob",do.patch,")\n",sep='')
        cat("src/",tar,":\n\tcurl -L -o $@ '",pkg$src,"'\n",sep='')
        chown <- paste0("\t", sudo, "chown -Rh 0:0 '$^'\n")
        ## don't use chown without sudo unless run as root
        if (!nzchar(sudo) && isTRUE(!as.vector(Sys.info()["effective_user"] == "root"))) chown <- ""
        cat(pv,"-",os.maj,"-",arch,".tar.gz: ",pv,"-dst\n\tif [ ! -e $^/",prefix,"/pkg ]; then mkdir $^/",prefix,"/pkg; fi\n\t(cd $^ && find ",prefix," > ", prefix, "/pkg/", pv,"-",os.maj,"-",arch,".list )\n", chown, "\ttar fcz '$@' -C '$^' ",dist,"\n", sep='')
    } else {
        cat(pv,"-",os.maj,"-",arch,".tar.gz:\n\tcurl -LO ",binary.url,"/$@\n",sep='')
    }
    cat(pv,": ",pv,"-",os.maj,"-",arch,".tar.gz\n\t", noinstall, sudo, "$(TAR) fxz '$^' -C /", prefix, " --strip ", ndir, " && echo 'Package: ",pkg$pkg,"~Version: ",pkg$ver,"~Depends: ", pkg$d$Depends, "~BuiltWith: ",dep.targets(pkg$dep,", "),"~BuiltFor: ",os.maj,"-",arch,"~Binary: ",pv,"-",os.maj,"-",arch,".tar.gz~' | tr '~' '\\n' > '$@' && touch '$@'\n",sep='')
    cat(pkg$pkg,": ",pv,"\n\n",sep='')
}
cat("\n\nall: ", paste(sapply(pkgs, function(o) if (!is.null(o$ver)) paste(o$pkg, o$ver, sep='-') else ''), collapse=' '), "\n\n", sep='')
sink()

cat("\nCreated build/Makefile\n\nUse make -C build <recipe> to build and install a recipe\n\n")
