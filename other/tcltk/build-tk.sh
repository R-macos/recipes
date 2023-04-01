#!/bin/sh

VER=8.6.13
OSVER=`uname -r | sed -E 's:^([0-9]+\.[0-9]+)\..*:\1:'`
ARCH=`uname -m`

if [ ! -e tk${VER}-src.tar.gz ]; then
curl -LO https://downloads.sourceforge.net/project/tcl/Tcl/${VER}/tk${VER}-src.tar.gz
fi
rm -rf tk${VER}
tar fxz tk${VER}-src.tar.gz

## we have to add missing .pc files for XQuartz
if [ ! -e pkgconfig/xproto.pc ]; then
  patch -p1 < pkgconfig.patch
fi

# no, we have to buidl against XQuartz
#export CPPFLAGS=-I/opt/R/${ARCH}/include
#export LDFLAGS=-L/opt/R/${ARCH}/lib
# not yet # export CFLAGS="-arch ${ARCH} -arch x86_64"
export CC=clang
export CXX=clang++
export PREFIX=/opt/R/${ARCH}
export PATH=/opt/R/${ARCH}/bin:$PATH

WD="`pwd`"
cd tk${VER}/unix

export PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig:/opt/X11/share/pkgconfig:$WD/pkgconfig:/opt/R/${ARCH}/lib/pkgconfig:/usr/lib/pkgconfig

./configure --prefix=/opt/R/${ARCH} --disable-corefoundation --disable-framework --disable-aqua --enable-xft
make -j12 && make install DESTDIR="$WD/dst-tk"

cd "$WD"

chmod -R g+w dst-tk
## tk uses invalid ID, need to fix it...
install_name_tool -id /opt/R/${ARCH}/lib/libtk8.6.dylib dst-tk/opt/R/${ARCH}/lib/libtk8.6.dylib 
tar fcz tk${VER}-xft-darwin${OSVER}-${ARCH}.tar.gz -C dst-tk --gid 80 --uid 0 opt/R/${ARCH}
