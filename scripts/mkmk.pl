#!/usr/bin/perl
## this script generates build/Makefile
## which is used to build libraries according to the recipes

my $default_prefix = "usr/local";

my $root = `pwd`;
chomp $root;

my @f = map { /[.~]/ ? () : ($_) } <recipes/*>;

my $binary = $ENV{"BINARY"} + 0;
my $binary_url = $ENV{"BINARY_URL"} + 0;
my $noinstall = $ENV{"NOINSTALL"} + 0 > 0 ? "#" : "";

my %pkgs;

my $bin = "$root/bin";

my $prefix = $ENV{"PREFIX"};
$prefix = $default_prefix if ($prefix eq '');

## strip any leading / - it has to be a relative path and no double //
$prefix =~ s/^\/+//;

my @pparts = split /\/+/, $prefix; 
my $ndir = @pparts;

my $sudo = ($ENV{"NOSUDO"} + 0) > 0 ? "" : "sudo ";

sub read_dcf {
    my %h;
    my $fn = $_[0], $key, $par = 1;
    open IN, $fn || die "Cannot open $fn";
    while (<IN>) {
	chomp;
	if (/^([#A-Za-z\._0-9\-]+):\s*(.*)$/) {
	    if ($section > 1) {
		print STDERR "WARNING: more than one paragraph in $fn, ignoring\n";
		return %h;
	    }
	    $key = lc($1);
	    my $val = $2;
	    if ($h{$key} ne '') {
		print STDERR "WARNING: duplicate section '$key' in $fn\n";
		$h{$key} .= " $val";
	    } else {
		$h{$key} = $val;
	    }
	} elsif (/^\s+(.*)/) {
	    if ($key eq '') {
		print STDERR "ERROR: invalid DCF file $fn, continuation without parent: $_\n";
		exit 1;
	    }
	    if ($section > 1) {
		print STDERR "WARNING: more than one paragraph in $fn, ignoring\n";
		return %h;
	    }
	    $h{$key} .= " $_";
	} elsif (/^$/) {
	    $section++;
	} else {
	    print STDERR "ERROR: invalid DCF file $fn: $_\n";
	    exit 1;
	}
    }
    return %h;
}

sub get_deps {
    my @a = split /\s*,\s*/, $_[0];
    return map {
	my %d;
	my $pkg = $_;
	if (/(.*) \(([<=>]+)\s*([0-9.]+)\)/) {
	    $d{'op'} = $2;
	    $d{'ver'} = $3;
	    $pkg = $1;
	}
	$d{'name'} = $pkg;
	\%d;
    } @a;
}

foreach $fn (@f) {
    my %d = read_dcf($fn);
    my $ver = $d{"version"};

    ## replace ${prefix} with the prefix
    foreach (keys %d) { $d{$_} =~ s/\$\{prefix\}/$prefix/ge; }
    ## replace ${ver} with the version
    foreach (keys %d) { $d{$_} =~ s/\$\{ver\}/$ver/ge; }

    my $src = $d{"source.url"};
    my $pkg = $d{"package"};
    my $dep = $d{"depends"};

#    print "=== $fn:\n";
#    foreach (sort(keys(%d))) { print "$_: $d{$_}\n"; }

    my @deps = get_deps($dep);
#    print "$fn: '$dep' "; foreach (@deps) { my %h=%$_; print "[$h{name}] "; }; print "\n";

    if ($ver eq '' && $src eq '') { ## virtual
	$pkgs{$pkg} = { pkg => $pkg, dep => \@deps, d => \%d };
    } else {
	$patch = (-e "$root/$fn.patch") ? "$root/$fn.patch" : "";
	$pkgs{$pkg} = { pkg => $pkg, ver => $ver, dep => \@deps, src => $src, d => \%d, patch => $patch };
    }
}

my $ok = 1;

## check dependencies
foreach my $name (keys %pkgs) {
    my %pkg = %{$pkgs{$name}};
    foreach my $c (@{$pkg{dep}}) {
	my %cond = %$c;
	if ($cond{name} ne '') {
	    if (! defined $pkgs{$cond{name}}) {
		print STDERR "ERROR: $name requires $cond{name} for which we have no recipe";
		$ok = 0;
	    } elsif ($cond{op} ne '') {
		if ($cond{op} ne ">=") {
		    print STDERR "WARNING: $name uses condition $cond{name} $cond{op} $cond{ver}, but we only supprot >= operators at this point";
		} else {
# FIXME: implement version comparison
#                   if (pkgs[[cond$name]]$nver < cond$version) {
#		       message("ERROR: ", pkg, "requires ",cond$name," ",cond$op, " ", as.character(cond$version), ", but ", cond$name, " is only available in ", pkgs[[cond$name]]$ver)
#			ok <- FALSE
#                   }
		}
	    }
	}
    }
    if (!$ok) {
	print STDERR "=== bailing out, dependencies not met ===\n\n";
	exit 1;
    }
}

my $os = lc `uname`; chomp $os;
my $arch = lc `uname -m`; chomp $arch;
my $os_ver = `uname -r`; chomp $os_ver;
my $os_maj = $os_ver;
$os_maj =~ s/\..*//;
$os_maj = "$os.$os_maj";

## auto-detect the binaries to pull from mac.R-project.org
if ($binary && $binary_url eq '') {
    if ($os eq "darwin") {
	print STDERR "BINARY_URL must be set for anythign other than macOS\n";
	exit 1;
    }
    if ($arch eq "arm64") {
        $os_maj = "darwin.20";
        $binary_url = "https://mac.r-project.org/libs-arm64";
    } else {
        $os_maj = "darwin.17";
	$binary_url = "https://mac.r-project.org/libs-4";
    }
}

## default flags
$cfgflags = "--with-pic --disable-shared --enable-static";

sub cfg {
    my %d = %{$_[0]};
    ## set the default cfgflags unless Configure.script is set
    ## in which case we can't assume it is autoconf-based
    my @f;
    push @f, $cfgflags if ($d{'configure.script'} eq '' && $d{'build-system'} eq '');
    foreach (("configure", "configure.$os", "configure.$os_maj", "configure.$arch",
	      "configure.$os.$arch", "configure.$os_maj.$arch")) {
	push @f, $d{$_} if ($d{$_} ne '');
    }

    ## this is not completely fool-proof, but we try to accept --prefix overrides and not step on them
    my $tst = ' ' . join ' ', @f;
    @f = ("--prefix=/$prefix", @f) if (!($d{'configure.script'} ne '' || $tst =~ / --prefix=/));
    
    return join ' ', @f;
}

system "mkdir -p build/src 2>/dev/null";
open OUT, ">build/Makefile" || die "ERROR: cannot create build/Makefile";

my $TAR = $ENV{"TAR"};
$TAR = 'tar' if ($TAR eq '');
print OUT "TAR='$TAR'\nPREFIX='$prefix'\n\n";

sub dep_targets {
    return join ' ', map {
	my %d = %$_;
	my $name = $d{name};
	my %p = %{$pkgs{$name}};
	($p{ver} eq '') ? $name : "$name-$p{ver}";
    } @{$_[0]};
}

## quote string using ' quotes
sub shQuote {
    my $a = $_[0];
    $a =~ s/'/'\\''/g; ## ' -> '\''
    $a = "'$a'";
    ## in case quoted ' is first or last remove the empty string
    $a =~ s/^''//;
    $a =~ s/''$//;
    return $a;
}

foreach my $name (sort keys %pkgs) {
    my %pkg = %{$pkgs{$name}};
    my %d = %{$pkg{d}};
    my $pv = "$pkg{pkg}-$pkg{ver}";
    my $bsys = ($d{'build-system'} ne '') ? $d{'build-system'} : '';
    if ($bsys ne '') {
	$bsys = "$root/scripts/configure.$bsys";
	if (! -e $bsys) {
	    print STDERR "ERROR: I can't find driver for the build system $bsys (package $pkg{pkg})\n";
	    exit 1;
	}
    }

    my $dist = ($d{'distribution.files'} ne '') ? $d{'distribution.files'} : $prefix;
    my $srcdir = ($d{'configure.subdir'} ne '') ? "/$d{'configure.subdir'}" : '';
    my $cfg_scr = ($d{'configure.script'} ne '') ? $d{'configure.script'} : 'configure';
    my $cfg_proc = ($d{'configure.driver'} ne '') ? $d{'configure.driver'} : '';
    my $cfg_chmod = ($d{'configure.chmod'} ne '') ? $d{'configure.chmod'} : '';
    my $mkinst = ($d{'install'} ne '') ? $d{'install'} : "make install";
    my $tar = $pkg{src};
    $tar =~ s/.*\///;
    if ($pkg{ver} eq '') { ## virtual
	print OUT "$pkg{pkg}: ".dep_targets($pkg{dep})."\n\ttouch '\$\@'\n";
	next;
    }

    if (!$binary) {
        if ($d{special} =~ /in-sources/) { ## requires in-sources install
	    $cfg_chmod = "chmod $cfg_chmod ".shQuote($cfg_scr)." && " if ($cfg_chmod ne '');
	    print OUT "$pv-dst: src/$pv ".dep_targets($pkg{dep})."\n\trm -rf $pv-obj && rsync -a src/$pv$srcdir/ $pv-obj/ && cd $pv-obj && ${cfg_chmod}PREFIX=$prefix $cfg_proc ./$cfg_scr ".cfg($pkg{d})." && PREFIX=$prefix make -j12 && PREFIX=$prefix $mkinst DESTDIR=$root/build/$pv-dst\n\n";
        } else {
	    $cfg_chmod = "chmod $cfg_chmod ".shQuote("../src/$pv$srcdir/$cfg_scr")." && " if ($cfg_chmod ne '');
	    print OUT "$pv-dst: src/$pv ".dep_targets($pkg{dep})."\n\trm -rf $pv-obj && mkdir $pv-obj && cd $pv-obj && ${cfg_chmod}PREFIX=$prefix $cfg_proc ../src/$pv$srcdir/$cfg_scr ".cfg($pkg{d})." && PREFIX=$prefix make -j12 && PREFIX=$prefix $mkinst DESTDIR=$root/build/$pv-dst\n\n";
        }
        $do_patch = ($pkg{patch} ne '') ? "&& patch -p1 < ".shQuote($pkg{patch}) : '';
	$do_patch = "$do_patch && cp ". shQuote($bsys) ." configure" if ($bsys ne '');
	print OUT "src/$pv: src/$tar\n\tmkdir -p src/$pv && (cd src/$pv && \$(TAR) fxj ../$tar && mv */* . $do_patch)\n";
        print OUT "src/$tar:\n\tcurl -L -o \$\@ '$pkg{src}'\n";
        $chown = "\t${sudo}chown -Rh 0:0 '\$^'\n";
        ## don't use chown without sudo unless run as root
	## FIXME: unimplemented
        ##if (!nzchar(sudo) && isTRUE(!as.vector(Sys.info()["effective_user"] == "root"))) chown <- ""
        print OUT "$pv-$os_maj-$arch.tar.gz: $pv-dst\n\tif [ ! -e \$^/$prefix/pkg ]; then mkdir \$^/$prefix/pkg; fi\n\t(cd \$^ && find $prefix > $prefix/pkg/$pv-$os_maj-$arch.list )\n$chown\ttar fcz '\$\@' -C '\$^' $dist\n";
    } else {
        print OUT "$pv-$os_maj-$arch.tar.gz:\n\tcurl -LO $binary_url/\$\@\n";
    }
    print OUT "$pv: $pv-$os_maj-$arch.tar.gz\n\t$noinstall$sudo\$(TAR) fxz '\$^' -C /$prefix --strip $ndir && touch '\$\@'\n";
    print OUT "$pkg{pkg}: $pv\n\n";
}
#for (pkg in virt) {
#    cat(pkg$pkg,": ",dep.targets(pkg$dep),"\n\ttouch '$@'\n")
#}

print OUT "\n\nall: ". join(' ', map { ($pkgs{$_}{ver}) ? $pkgs{$_}{pkg}.'-'.$pkgs{$_}{ver} : ''; } sort keys %pkgs). "\n\n";
close OUT;

print "\nCreated build/Makefile\n\nUse make -C build <recipe> to build and install a recipe\n\n";

