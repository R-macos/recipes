#!/bin/bash

osname=`uname -s`
osarch=`uname -m` 

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
if [ x"$1" = x-f ]; then
  rm -f build/Makefile
  shift
fi

## need to create Makefile?
if [ ! -e build/Makefile ]; then
  if [ -z "$RSBIN" ]; then
    echo "ERROR: cannot find Rscript binary. Set PATH or RSBIN accordingly." >&2
    exit 1
  fi

  if "$RSBIN" scripts/mkmk.R; then
    echo 'build/Makefile created.'
  else
    echo "ERROR: mkmk.R failed" >&2
    exit 1
  fi 
fi

if [ x"$osname" = xDarwin ]; then
  PWD=`pwd`
  export PKG_CONFIG_PATH=/$PREFIX/lib/pkgconfig:$PWD/stubs/pkgconfig-darwin:/usr/lib/pkgconfig
 
  make -C build $* 
fi

