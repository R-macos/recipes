#!/bin/sh

VER=8.6.12
OSVER=`uname -r | sed -E 's:^([0-9]+\.[0-9]+)\..*:\1:'`
ARCH=`uname -m`

curl -LO https://downloads.sourceforge.net/project/tcl/Tcl/${VER}/tcl${VER}-src.tar.gz
tar fxz tcl${VER}-src.tar.gz

export CC=clang
export CXX=clang++
export PREFIX=/opt/R/${ARCH}
export PATH=/opt/R/${ARCH}/bin:$PATH

WD="`pwd`"
cd tcl${VER}/unix

./configure --prefix=/opt/R/${ARCH} --disable-corefoundation --disable-framework
make -j12 && make install DESTDIR="$WD/dst-tcl"

cd "$WD"
chmod -R g+w dst-tcl

tar fcz tcl${VER}-darwin${OSVER}-${ARCH}.tar.gz -C dst-tcl --gid 80 --uid 0 opt/R/${ARCH}
