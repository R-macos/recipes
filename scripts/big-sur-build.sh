#!/bin/bash

set -e

if [ ! -e build.sh ]; then
    echo "Please run this script from the root of the recipes" >&2
    exit 1
fi

while (( "$#" )); do
    if [ "x$1" = x--tools ]; then RUN_TOOLS=1; fi
    if [ "x$1" = x--all ]; then RUN_ALL=1; fi
    if [ "x$1" = x--cran ]; then AS_CRAN=1; fi
    if [ "x$1" = x-h -o "x$1" = x--help ]; then
	echo ''
	echo " Usage: $0 [-h|--help] [--cran] [--tools | --all]"
	echo ''
	echo " Default is --base (r-base-dev), tools include emacs and subversion."
	echo ''
	echo ' --cran enforces existence of all tools and locations, otherwise'
	echo '        they are optional'
	echo ''
	exit 0
    fi
    shift
done

if [ -n "$AS_CRAN" ]; then
    ENVOK=yes
    echo Checking build environment ...
    if [ ! -e /Volumes/Temp ]; then
	echo "ERROR: /Volumes/Temp does not exist!" >&2
	ENVOK=no
    else
	if [ ! -e /Volumes/Temp/tmp ]; then
	    mkdir -p /Volumes/Temp/tmp
	fi
	echo " - /Volumes/Temp/tmp OK"
    fi
    if [ ! -e /Library/Developer/CommandLineTools/SDKs/MacOSX11.sdk ]; then
	echo "ERROR: macOS 11 SDK is missing" >&2
	ENVOK=no
    else
	echo " - SDK OK"
    fi
    if [ ! -e /Applications/CMake.app/Contents/bin/cmake ]; then
	echo "ERROR: CMake is missing" >&2
	ENVOK=no
    else
	echo " - CMake OK"
    fi
    if ! command -v meson > /dev/null; then
	PYLIB=$(ls -d ~/Library/Python/3.*/bin | tail -n1)
	if [ -n "$PYLIB" ]; then
	    export PATH=$PATH:$PYLIB
	    echo " - Adding Python 3 user library to PATH"
	fi
    fi
    if ! command -v meson > /dev/null; then
	echo " - Installing meson"
	pip3 install --user meson
    fi
    if ! command -v ninja > /dev/null; then
	echo " - Installing ninja"
	pip3 install --user ninja
    fi
    command -v meson
    command -v ninja
    if [ ! -e ~/.gnu-mirror ]; then
	## GNU server is terribly slow so set a more sane mirror
	echo https://mirror.endianness.com/gnu/ > ~/.gnu-mirror
    fi
    export PREFIX="opt/R/`uname -m`"
    echo Setup target /$PREFIX
    if [ ! -e "/$PREFIX" ]; then
	mkdir -p "/$PREFIX"
    fi
fi

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
echo ''
echo " ----- Bootstrapping freetype"
echo ''
./build.sh -f -p freetype
./build.sh -f -p harfbuzz
rm -rf build/freetype-2.*
echo ''
echo " ----- Re-building freetype with Harfbuzz"
echo ''
./build.sh -f -p freetype

## required
echo ''
echo " ----- Building r-base-dev"
echo ''
./build.sh -f -p r-base-dev

## NOTE: CRAN R also uses: readline5 pango
if [ -n "$AS_CRAN" ]; then
    ./build.sh -f -p readline5
    ## pango has to be built last due to glib causing issues
fi

## useful
if [ -n "$RUN_TOOLS" ]; then
    echo ''
    echo " ----- Building tools"
    echo ''
    ./build.sh -f -p subversion emacs
fi

## all others
if [ -n "$RUN_ALL" ]; then
    echo ''
    echo " ----- Building all"
    echo ''
    ./build.sh -f -p all
fi

echo ''
echo ' NOTE: if you want to disable fail-fast, use'
echo ' ./build.sh -f -p -- -k all'

echo ''
echo "=== DONE"
echo ''
echo 'Consider running scripts/mkdist.pl'
echo ''
