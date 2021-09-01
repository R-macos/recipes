#!/bin/bash
#
# settings used to bootstrap libraries on CRAN for arm64 R builds

## desination, __no__ leading slash!
DSTPATH=opt/R/arm64

if [ ! -e /Library/Frameworks/R.framework/Resources/bin/Rscript ]; then
    echo ''
    echo 'ERROR: R framework not found. Please install R from CRAN first (just framework is sufficient)'
    echo ''
    exit 1
fi

if [ ! -e scripts/mkmk.R ]; then
    echo ''
    echo 'Please run this script from the recipes root directory via'
    echo ''
    echo '  scripts/bootstrap-darwin20-arm64.sh'
    echo ''
    exit 1
fi

if [ "x$1" = "x-h" ]; then
    echo ''
    echo ' Usage: scripts/bootstrap-darwin20-arm64.sh [-h|-a]'
    echo ''
    echo 'Must be run from the recipes root directory'
    echo 'Default invocation builds binaries necessary for R.'
    echo 'Option -a builds all recipes'
    echo ''
    exit 0
fi

if [ ! -e /$DSTPATH ]; then
    mkdir -p /$DSTPATH
    if [ ! -e /$DSTPATH ]; then
	echo ''
	echo "ERROR: cannot create /$DSTPATH"
	echo '       Please adjust permissions or create it yourself with something like:'
	echo ''
	echo " sudo mkdir -p /$DSTPATH"
	echo " sudo chown \$USER /$DSTPATH"
	echo ''
	exit 1
    fi
fi

NOSUDO=1 PREFIX=$DSTPATH /Library/Frameworks/R.framework/Resources/bin/Rscript scripts/mkmk.R 

## pkgconfig must be built first
NOSUDO=1 PREFIX=$DSTPATH PATH=/$DSTPATH/bin:$PATH PKG_CONFIG_PATH=/$DSTPATH/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig CC='clang -arch arm64' CXX='clang++ -arch arm64' OBJC='clang -arch arm64' CPPFLAGS=-I/$DSTPATH/include LDFLAGS=-L/$DSTPATH/lib make -C build pkgconfig

## add zlib system stub
cp -p stubs/pkgconfig-darwin/zlib.pc /$DSTPATH/lib/pkgconfig/

## build all R dependencies
NOSUDO=1 PREFIX=$DSTPATH PATH=/$DSTPATH/bin:$PATH PKG_CONFIG_PATH=/$DSTPATH/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig CC='clang -arch arm64' CXX='clang++ -arch arm64' OBJC='clang -arch arm64' CPPFLAGS=-I/$DSTPATH/include LDFLAGS=-L/$DSTPATH/lib make -C build \
      xz tiff libpng openssl jpeg pcre2 cairo texinfo

## external: to build R we also need gfortran which is not part of the recipes

## everything else is optional for packages
if [ "x$1" = x-a ]; then
    NOSUDO=1 PREFIX=$DSTPATH PATH=/$DSTPATH/bin:$PATH PKG_CONFIG_PATH=/$DSTPATH/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig CC='clang -arch arm64' CXX='clang++ -arch arm64' OBJC='clang -arch arm64' CPPFLAGS=-I/$DSTPATH/include LDFLAGS=-L/$DSTPATH/lib make -k -C build all
fi
