root <- getwd()

f <- Sys.glob("recipes/*")
bak <- grep("~$", f)
if (length(bak)) f <- f[-bak]

pkgs <- list()

bin <- file.path(root, "bin")

for (fn in f) {
    d <- read.dcf(fn)
    if (dim(d)[1] > 1L) {
        warning("File '", fn,"' has more than one section, using only the first one")
	d <- d[1,,drop=F]
    }
    db <- d[1,]
    d <- as.list(db)
    src <- d$Source.URL
    pkg <- d$Package
    ver <- d$Version
    nver <- if (length(grep("[a-zA-Z]$", ver))) {
        suf <- substr(ver, nchar(ver), nchar(ver))
	ver <- substr(ver, 1, nchar(ver) - 1)
        m <- match(suf, letters)
	if (is.na(m)) m <- match(suf, LETTERS)
	nver <- package_version(paste(ver, m, sep='-'))
    } else package_version(ver)
    dep <- d$Depends
    dep <- if (length(dep) && any(nzchar(dep))) tools:::.get_requires_with_version_from_package_db(db, "Depends") else list()
    pkgs[[pkg]] <- list(pkg=pkg, ver=ver, nver=nver, dep=dep, src=src, d=d)
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
                   message("ERROR: ",pkg," uses condition ",cond$name," ",cond$op, " ", as.character(cond$version), ", but we only supprot >= operators at thsi point")
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

cfgflags=c("--with-pic --disable-shared --enable-static")
cfg <- function(d) {
    f <- cfgflags
    if (!is.null(d[["Configure"]])) f <- c(f, d[["Configure"]])
    if (!is.null(d[[paste0("Configure.",os)]])) f <- c(f, d[[paste0("Configure.",os)]])
    if (!is.null(d[[paste0("Configure.",os.maj)]])) f <- c(f, d[[paste0("Configure.",os.maj)]])
    if (!is.null(d[[paste0("Configure.",arch)]])) f <- c(f, d[[paste0("Configure.",arch)]])
    if (!is.null(d[[paste0("Configure.",os,".",arch)]])) f <- c(f, d[[paste0("Configure.",os,".",arch)]])
    if (!is.null(d[[paste0("Configure.",os.maj,".",arch)]])) f <- c(f, d[[paste0("Configure.",os.maj,".",arch)]])
    paste(f, collapse=" ")
}

tryCatch(system("mkdir -p build/src 2>/dev/null"), error=function(e) NULL)
sink("build/Makefile")

TAR <- Sys.getenv("TAR")
if (!nzchar(TAR)) TAR <- "tar"
cat("TAR='", TAR, "'\n\n", sep='')

for (pkg in pkgs) {
    pv <- paste0(pkg$pkg,"-",pkg$ver)
    dist <- if (length(pkg$d$Distribution.files)) pkg$d$Distribution.files else "usr"
    srcdir <- if (length(pkg$d$Configure.subdir)) paste0("/",pkg$d$Configure.subdir[1L]) else ""
    if (length(grep("in-sources", pkg$d$Special))) { ## requires in-sources install
        cat(pv,"-dst: src/",pv," ",paste(sapply(pkg$dep, function(o) paste0(pkgs[[o$name]]$pkg,"-",pkgs[[o$name]]$ver)),collapse=' '),"\n\trm -rf ",pv,"-obj && rsync -a src/",pv,srcdir,"/ ",pv,"-obj/ && cd ",pv,"-obj && ./configure ",cfg(pkg$d)," && make -j12 && make install DESTDIR=",root,"/build/",pv,"-dst\n\n", sep='')
    } else {
        cat(pv,"-dst: src/",pv," ",paste(sapply(pkg$dep, function(o) paste0(pkgs[[o$name]]$pkg,"-",pkgs[[o$name]]$ver)),collapse=' '),"\n\trm -rf ",pv,"-obj && mkdir ",pv,"-obj && cd ",pv,"-obj && ../src/",pv,srcdir,"/configure ",cfg(pkg$d)," && make -j12 && make install DESTDIR=",root,"/build/",pv,"-dst\n\n", sep='')
    }
    tar <- basename(pkg$src)
    cat("src/",pv,": src/",tar,"\n\tmkdir -p src/",pv," && (cd src/",pv," && $(TAR) fxj ../",tar," && mv */* .)\n",sep='')
    cat("src/",tar,":\n\tcurl -L -o $@ '",pkg$src,"'\n",sep='')
    cat(pv,"-",os.maj,"-",arch,".tar.gz: ",pv,"-dst\n\tsudo chown -Rh 0:0 '$^'\n\ttar fcz '$@' -C '$^' ",dist,"\n", sep='')
    cat(pv,": ",pv,"-",os.maj,"-",arch,".tar.gz\n\tsudo $(TAR) fxz '$^' -C / && touch '$@'\n",sep='')
    cat(pkg$pkg,": ",pv,"\n\n",sep='')
}
cat("\n\nall: ", paste(sapply(pkgs, function(o) paste(o$pkg, o$ver, sep='-')), collapse=' '), "\n\n", sep='')
sink()
