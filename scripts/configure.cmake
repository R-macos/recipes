#!/bin/bash
# This is a small wrapper that makes cmake work in autoconf setting
# (C)2021 Simon Urbanek, License: MIT
# based on ideas by Brian Ripley

echo -n 'Checking for cmake ... '
: ${CMAKE=`which cmake`}
# on macOS CMake is an application
if [ -z "$CMAKE" -a -e "/Applications/CMake.app/Contents/bin/cmake" ]; then
    CMAKE=/Applications/CMake.app/Contents/bin/cmake
fi
if [ -z "$CMAKE" ]; then
    echo 'NOT FOUND'
    echo 'ERROR: cannot find cmake! This package requires cmake to build'
    exit 1
fi
echo $CMAKE
echo -n 'Checking if it works ...'
if $CMAKE --version >/dev/null; then
    echo yes
else
    echo NO
    echo 'ERROR: cannot find cmake! This package requires cmake to build'
    exit 1
fi

BD="`pwd`"
SD="`dirname $0`"
SD="`(cd $SD && pwd)`"

echo Collecting env vars from arguments:
while (( "$#" )); do
    if echo "$1" | grep -E '^[A-Z]+=' >/dev/null; then
	export "$1"
	echo "  $1"
    else
	if echo "$1" | grep '^--prefix='; then
	    PREFIX=`echo $1 | sed 's:^--prefix=/*::'`
	    MARGS+=("-DCMAKE_INSTALL_PREFIX=/$PREFIX")
	else
	    MARGS+=("$1")
	fi
    fi
    shift
done

echo Invoking cmake:
set -x
(cd "$BD" && $CMAKE "$SD" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS:bool=OFF -DCMAKE_POSITION_INDEPENDENT_CODE:bool=ON  "${MARGS[@]}" ) || (echo '*** FAILED' >&2; exit 1)
set +x

echo "Makefile generated."
