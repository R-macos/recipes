#!/bin/sh

VER=2.10
OSVER=`uname -r | sed -E 's:^([0-9]+\.[0-9]+)\..*:\1:'`
ARCH=`uname -m`

curl -LO https://fossies.org/linux/privat/Tktable${VER}.tar.gz
tar fxz Tktable${VER}.tar.gz
(cd Tktable${VER} && patch -p1 < ../Tktable${VER}.patch)

export PATH=/opt/R/${ARCH}/bin:$PATH

WD="`pwd`"
cd Tktable${VER}
./configure
make -j12 && make install DESTDIR="$WD/dst-tkt"

cd "$WD"
chmod -R g+w dst-tkt

tar fcz tktable${VER}-darwin${OSVER}-${ARCH}.tar.gz -C dst-tkt --gid 80 --uid 0 opt/R/${ARCH}
