#!/bin/bash

osname=`uname -s`
osarch=`uname -m` 

## it is too tedious to maintain two paths, so Perl generator is now
## default (since it's required for bootstrap anyway) and R is deprecated
: ${PERL=$(command -v perl)}

args=($@)
for ((i=1;i<=$#;i++)); do
    case "x${!i}" in
	x--) unset args[$i-1]; break;;
	x-f) FORCE=1; unset args[$i-1];;
	x-b) BINARY=1; unset args[$i-1];;
	x-p) PERL=$(command -v perl); unset args[$i-1]; if [ -z "$PERL" ]; then PERL=perl; fi;;
	x-h)
	    echo ''
	    echo " Usage: $0 [-f] [-b] [-p] [-h] [[--] ...]"
	    echo ''
	    echo ' -f  - create builds/Makefile even if it exists'
	    echo ' -b  - install from binaries'
	    echo ' -p  - use Perl even if R is present'
	    echo ' --  - any further arguments are passed ann not interpreted'
	    echo ' -h  - this help page'
	    echo ' ... additional arguments passed to make'
	    echo ''
	    echo 'The builds are performed in the "builds" subdirectory'
	    echo ''
	    exit 0;;
    esac
done

## auto-detect PREFIX if not specified
if [ -z "$PREFIX" -a x$OSARCH = xarm64 -a x$osname = xDarwin ]; then
  PREFIX=opt/R/arm64
fi
if [ -z "$PREFIX" ]; then
  if [ -e "/opt/R/$osarch" ]; then
    PREFIX="opt/R/$osarch"
  else
    PREFIX=usr/local
  fi
fi

## fall back to CMake.app if necessary
if [ -e /Applications/CMake.app/Contents/bin/cmake ]; then
    PATH=$PATH:/Applications/CMake.app/Contents/bin
fi

## make sure prefix is first on the PATH
export PATH=/$PREFIX/bin:/$PREFIX/sbin:$PATH

## make sure there are no leading slashes
PREFIX=`echo $PREFIX | sed 's:^/*::'`

## $PREFIX paths have to be in the flags except for /usr and /usr/local
if [ /"$PREFIX" != /usr/local -a "/$PREFIX" != /usr ]; then
  if [ -z "$CPPFLAGS" ]; then
    export CPPFLAGS="-I/$PREFIX/include"
  fi
  if [ -z "$LDFLAGS" ]; then
    export LDFLAGS="-L/$PREFIX/lib"
  fi
fi

## find R
: ${RSBIN=`which Rscript`}
if [ -z "$RSBIN" ]; then
  for pp in /usr/bin /usr/local/bin /opt/R/$osarch/bin /Library/Frameworks/R.framework/Resources/bin; do
    if [ -x "$pp/Rscript" ]; then
      RSBIN="$pp/Rscript"
    fi
  done
fi

echo "Building for $osname ($osarch):"
echo "install prefix: /$PREFIX"

export PREFIX

if [ ! -e "/$PREFIX/bin" ]; then
    mkdir -p "/$PREFIX/bin" 2> /dev/null ## ok to fail, we deal with sudo later
fi

if touch /$PREFIX/bin/.1; then
  echo "sudo not required"
  export NOSUDO=1
  rm /$PREFIX/bin/.1
else
  if [ -n "$NOSUDO" ]; then
    echo "ERROR: NOSUDO is set, but /$PREFIX is not writable!" >&2
    exit 1
  fi
  echo "sudo required for installation"
fi

## if -f is used we re-build the Makefile regardless
if [ -n "$FORCE" ]; then
  rm -f build/Makefile
fi

## need to create Makefile?
if [ ! -e build/Makefile ]; then
    if [ -n "$PERL" -o -z "$RSBIN" ]; then
	: ${PERL=`which perl`}
	if [ -z "$PERL" ]; then
	    X=`perl -e 'print 1;'`
	    if [ x$X = x1 ]; then
		PERL=perl
	    else
		echo "ERROR: neither R nor Perl found. Please, install either and make sure it is on the PATH."
		exit 1
	    fi
	fi
	RUN="$PERL scripts/mkmk.pl"
	echo "Using Perl generator ($PERL)"
    else
	RUN="$RSBIN scripts/mkmk.R"
	echo "Using R generator ($RSBIN)"
    fi

    if $RUN; then
	echo 'build/Makefile created.'
	echo ''
    else
	echo "ERROR: Makefile generation failed" >&2
	exit 1
    fi
fi

if [ x"$osname" = xDarwin ]; then
  PWD=`pwd`
  export PKG_CONFIG_PATH=/$PREFIX/lib/pkgconfig:$PWD/stubs/pkgconfig-darwin:/usr/lib/pkgconfig
fi

set -e
make -C build "${args[@]}"
