#!/bin/bash

set -e

if [ ! -e build.sh ]; then
    echo "Please run this script from the root of the recipes" >&2
    exit 1
fi

while (( "$#" )); do
    if [ "x$1" = x--tools ]; then RUN_TOOLS=1; fi
    if [ "x$1" = x--all ]; then RUN_ALL=1; fi
    if [ "x$1" = x-h -o "x$1" = x--help ]; then
	echo ''
	echo " Usage: $0 [-h|--help] [--tools | --all]"
	echo ''
	echo " Default is --base (r-base-dev), tools include emacs and subversion."
	echo ''
	exit 0
    fi
    shift
done

if [ -e /Volumes/Temp/tmp ]; then
    export TMPDIR=/Volumes/Temp/tmp
fi

if [ -e /Library/Developer/CommandLineTools/SDKs/MacOSX11.sdk ]; then
    export SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX11.sdk
else
    echo "WARNING: MacOSX11.sdk not present, using default SDK which may be newer!"
fi

export MACOSX_DEPLOYMENT_TARGET=11.0
export OS_VER=20

# for cmake, meson and ninja

if [ -e /Applications/CMake.app/Contents/bin ]; then
    export PATH=$PATH:/Applications/CMake.app/Contents/bin
fi

if ! command -v cmake > /dev/null; then
    echo "ERROR: cmake not found" >&2
    exit 1
fi

if command -v meson > /dev/null && command -v ninja > /dev/null; then
    echo "ninja and meson are already on the PATH"
else
    PYLIB=$(ls -d ~/Library/Python/3.*/bin | tail -n1)
    if [ -z "$PYLIB" ]; then
	echo "ERROR: cannot find Python 3 binaries. Use pip3 install --user meson ninja"
	exit 1
    fi
    export PATH=$PATH:$PYLIB
    if command -v meson > /dev/null && command -v ninja > /dev/null; then
	echo "ninja and meson found in $PYLIB"
    else
	echo "ERROR: cannot find ninja/meson 3 binaries. Use pip3 install --user meson ninja"
	exit 1
    fi
fi

## freetype and harfbuzz have a circular dependency
## and need to be bootstrapped in the order FT -> HB -> FT
./build.sh -f -p freetype
./build.sh -f -p harfbuzz
rm -rf build/freetype-2.*

## required
./build.sh -f -p r-base-dev

## NOTE: CRAN R also uses: readline5 pango

## useful
if [ -n "$RUN_TOOLS" ]; then
    ./build.sh -f -p subversion emacs
fi

## all others
if [ -n "$RUN_ALL" ]; then
    ./build.sh -f -p all
fi

## NOTE: if you want to disable fail-fast, use
## ./build.sh -f -p -- -k all

echo ''
echo "=== DONE"
echo ''
echo 'Consider running scripts/mkdist.pl'
echo ''
