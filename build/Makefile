TAR='/usr/bin/tar'

QuantLib-1.18-dst: src/QuantLib-1.18 boost-1.73.0
	rm -rf QuantLib-1.18-obj && mkdir QuantLib-1.18-obj && cd QuantLib-1.18-obj &&  ../src/QuantLib-1.18/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/QuantLib-1.18-dst

src/QuantLib-1.18: src/QuantLib-1.18.tar.gz
	mkdir -p src/QuantLib-1.18 && (cd src/QuantLib-1.18 && $(TAR) fxj ../QuantLib-1.18.tar.gz && mv */* . )
src/QuantLib-1.18.tar.gz:
	curl -L -o $@ 'https://dl.bintray.com/quantlib/releases/QuantLib-1.18.tar.gz'
QuantLib-1.18-darwin.17-x86_64.tar.gz: QuantLib-1.18-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
QuantLib-1.18: QuantLib-1.18-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
QuantLib: QuantLib-1.18

bdb-6.2.23-dst: src/bdb-6.2.23 
	rm -rf bdb-6.2.23-obj && mkdir bdb-6.2.23-obj && cd bdb-6.2.23-obj &&  ../src/bdb-6.2.23/dist/configure --enable-stl --prefix=/usr/local && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/bdb-6.2.23-dst

src/bdb-6.2.23: src/db-6.2.23.tar.gz
	mkdir -p src/bdb-6.2.23 && (cd src/bdb-6.2.23 && $(TAR) fxj ../db-6.2.23.tar.gz && mv */* . && patch -p1 < '/Volumes/Builds/recipes/recipes/bdb.patch')
src/db-6.2.23.tar.gz:
	curl -L -o $@ 'http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz'
bdb-6.2.23-darwin.17-x86_64.tar.gz: bdb-6.2.23-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
bdb-6.2.23: bdb-6.2.23-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
bdb: bdb-6.2.23

boost-1.73.0-dst: src/boost-1.73.0 
	rm -rf boost-1.73.0-obj && mkdir boost-1.73.0-obj && cd boost-1.73.0-obj && sh ../src/boost-1.73.0/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/boost-1.73.0-dst

src/boost-1.73.0: src/boost_1_73_0.tar.gz
	mkdir -p src/boost-1.73.0 && (cd src/boost-1.73.0 && $(TAR) fxj ../boost_1_73_0.tar.gz && mv */* . && patch -p1 < '/Volumes/Builds/recipes/recipes/boost.patch')
src/boost_1_73_0.tar.gz:
	curl -L -o $@ 'https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.gz'
boost-1.73.0-darwin.17-x86_64.tar.gz: boost-1.73.0-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
boost-1.73.0: boost-1.73.0-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
boost: boost-1.73.0

cairo-1.14.12-dst: src/cairo-1.14.12 freetype-2.10.0 fontconfig-2.13.1 libpng-1.6.37 pixman-0.38.4
	rm -rf cairo-1.14.12-obj && mkdir cairo-1.14.12-obj && cd cairo-1.14.12-obj &&  ../src/cairo-1.14.12/configure --with-pic --disable-shared --enable-static --disable-quartz-font --disable-quartz --disable-quartz-image --disable-qt && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/cairo-1.14.12-dst

src/cairo-1.14.12: src/cairo-1.14.12.tar.xz
	mkdir -p src/cairo-1.14.12 && (cd src/cairo-1.14.12 && $(TAR) fxj ../cairo-1.14.12.tar.xz && mv */* . )
src/cairo-1.14.12.tar.xz:
	curl -L -o $@ 'https://www.cairographics.org/releases/cairo-1.14.12.tar.xz'
cairo-1.14.12-darwin.17-x86_64.tar.gz: cairo-1.14.12-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
cairo-1.14.12: cairo-1.14.12-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
cairo: cairo-1.14.12

cairomm-1.11.2-dst: src/cairomm-1.11.2 cairo-1.14.12 sigc++-2.10.3
	rm -rf cairomm-1.11.2-obj && mkdir cairomm-1.11.2-obj && cd cairomm-1.11.2-obj &&  ../src/cairomm-1.11.2/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/cairomm-1.11.2-dst

src/cairomm-1.11.2: src/cairomm-1.11.2.tar.gz
	mkdir -p src/cairomm-1.11.2 && (cd src/cairomm-1.11.2 && $(TAR) fxj ../cairomm-1.11.2.tar.gz && mv */* . )
src/cairomm-1.11.2.tar.gz:
	curl -L -o $@ 'http://cairographics.org/releases/cairomm-1.11.2.tar.gz'
cairomm-1.11.2-darwin.17-x86_64.tar.gz: cairomm-1.11.2-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
cairomm-1.11.2: cairomm-1.11.2-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
cairomm: cairomm-1.11.2

ffi-3.3-dst: src/ffi-3.3 
	rm -rf ffi-3.3-obj && mkdir ffi-3.3-obj && cd ffi-3.3-obj &&  ../src/ffi-3.3/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/ffi-3.3-dst

src/ffi-3.3: src/libffi-3.3.tar.gz
	mkdir -p src/ffi-3.3 && (cd src/ffi-3.3 && $(TAR) fxj ../libffi-3.3.tar.gz && mv */* . )
src/libffi-3.3.tar.gz:
	curl -L -o $@ 'ftp://sourceware.org/pub/libffi/libffi-3.3.tar.gz'
ffi-3.3-darwin.17-x86_64.tar.gz: ffi-3.3-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
ffi-3.3: ffi-3.3-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
ffi: ffi-3.3

fftw-3.3.8-dst: src/fftw-3.3.8 
	rm -rf fftw-3.3.8-obj && mkdir fftw-3.3.8-obj && cd fftw-3.3.8-obj &&  ../src/fftw-3.3.8/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/fftw-3.3.8-dst

src/fftw-3.3.8: src/fftw-3.3.8.tar.gz
	mkdir -p src/fftw-3.3.8 && (cd src/fftw-3.3.8 && $(TAR) fxj ../fftw-3.3.8.tar.gz && mv */* . )
src/fftw-3.3.8.tar.gz:
	curl -L -o $@ 'http://www.fftw.org/fftw-3.3.8.tar.gz'
fftw-3.3.8-darwin.17-x86_64.tar.gz: fftw-3.3.8-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
fftw-3.3.8: fftw-3.3.8-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
fftw: fftw-3.3.8

fontconfig-2.13.1-dst: src/fontconfig-2.13.1 freetype-2.10.0
	rm -rf fontconfig-2.13.1-obj && mkdir fontconfig-2.13.1-obj && cd fontconfig-2.13.1-obj &&  ../src/fontconfig-2.13.1/configure --with-pic --disable-shared --enable-static --with-baseconfigdir=/Library/Frameworks/R.framework/Resources/fontconfig/fonts --with-cache-dir=/Library/Frameworks/R.framework/Resources/fontconfig/cache --with-default-fonts=/usr/X11/lib/X11/fonts --with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts --enable-libxml2 --datadir=/Library/Frameworks/R.framework/Resources/fontconfig && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/fontconfig-2.13.1-dst

src/fontconfig-2.13.1: src/fontconfig-2.13.1.tar.bz2
	mkdir -p src/fontconfig-2.13.1 && (cd src/fontconfig-2.13.1 && $(TAR) fxj ../fontconfig-2.13.1.tar.bz2 && mv */* . && patch -p1 < '/Volumes/Builds/recipes/recipes/fontconfig.patch')
src/fontconfig-2.13.1.tar.bz2:
	curl -L -o $@ 'https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2'
fontconfig-2.13.1-darwin.17-x86_64.tar.gz: fontconfig-2.13.1-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
fontconfig-2.13.1: fontconfig-2.13.1-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
fontconfig: fontconfig-2.13.1

freetype-2.10.0-dst: src/freetype-2.10.0 xml2-2.9.10 libpng-1.6.37
	rm -rf freetype-2.10.0-obj && mkdir freetype-2.10.0-obj && cd freetype-2.10.0-obj &&  ../src/freetype-2.10.0/configure --with-pic --disable-shared --enable-static --without-old-mac-fonts --without-fsspec --without-fsref --without--quickdraw-toolbox --without-quickdraw-carbon --without-ats && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/freetype-2.10.0-dst

src/freetype-2.10.0: src/freetype-2.10.0.tar.bz2
	mkdir -p src/freetype-2.10.0 && (cd src/freetype-2.10.0 && $(TAR) fxj ../freetype-2.10.0.tar.bz2 && mv */* . )
src/freetype-2.10.0.tar.bz2:
	curl -L -o $@ 'https://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2'
freetype-2.10.0-darwin.17-x86_64.tar.gz: freetype-2.10.0-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
freetype-2.10.0: freetype-2.10.0-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
freetype: freetype-2.10.0

freexl-1.0.6-dst: src/freexl-1.0.6 
	rm -rf freexl-1.0.6-obj && mkdir freexl-1.0.6-obj && cd freexl-1.0.6-obj &&  ../src/freexl-1.0.6/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/freexl-1.0.6-dst

src/freexl-1.0.6: src/freexl-1.0.6.tar.gz
	mkdir -p src/freexl-1.0.6 && (cd src/freexl-1.0.6 && $(TAR) fxj ../freexl-1.0.6.tar.gz && mv */* . )
src/freexl-1.0.6.tar.gz:
	curl -L -o $@ 'http://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.6.tar.gz'
freexl-1.0.6-darwin.17-x86_64.tar.gz: freexl-1.0.6-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
freexl-1.0.6: freexl-1.0.6-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
freexl: freexl-1.0.6

gdal-3.1.4-dst: src/gdal-3.1.4 xz-5.2.4 proj-6.3.1 openjpeg-2.3.1 libwebp-1.1.0 freexl-1.0.6
	rm -rf gdal-3.1.4-obj && rsync -a src/gdal-3.1.4/ gdal-3.1.4-obj/ && cd gdal-3.1.4-obj &&  ./configure --with-pic --disable-shared --enable-static --with-static-proj4=/usr/local --with-liblzma 'LIBS=-L/usr/local/pgsql/lib -lsqlite3 -lsz' 'CPPFLAGS=-I/usr/local/pgsql/include' && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/gdal-3.1.4-dst

src/gdal-3.1.4: src/gdal-3.1.4.tar.gz
	mkdir -p src/gdal-3.1.4 && (cd src/gdal-3.1.4 && $(TAR) fxj ../gdal-3.1.4.tar.gz && mv */* . && patch -p1 < '/Volumes/Builds/recipes/recipes/gdal.patch')
src/gdal-3.1.4.tar.gz:
	curl -L -o $@ 'https://github.com/OSGeo/gdal/releases/download/v3.1.4/gdal-3.1.4.tar.gz'
gdal-3.1.4-darwin.17-x86_64.tar.gz: gdal-3.1.4-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
gdal-3.1.4: gdal-3.1.4-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
gdal: gdal-3.1.4

geos-3.8.1-dst: src/geos-3.8.1 
	rm -rf geos-3.8.1-obj && mkdir geos-3.8.1-obj && cd geos-3.8.1-obj &&  ../src/geos-3.8.1/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/geos-3.8.1-dst

src/geos-3.8.1: src/geos-3.8.1.tar.bz2
	mkdir -p src/geos-3.8.1 && (cd src/geos-3.8.1 && $(TAR) fxj ../geos-3.8.1.tar.bz2 && mv */* . )
src/geos-3.8.1.tar.bz2:
	curl -L -o $@ 'http://download.osgeo.org/geos/geos-3.8.1.tar.bz2'
geos-3.8.1-darwin.17-x86_64.tar.gz: geos-3.8.1-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
geos-3.8.1: geos-3.8.1-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
geos: geos-3.8.1

glpk-4.65-dst: src/glpk-4.65 gmp-6.2.0
	rm -rf glpk-4.65-obj && mkdir glpk-4.65-obj && cd glpk-4.65-obj &&  ../src/glpk-4.65/configure --with-pic --disable-shared --enable-static --with-gmp && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/glpk-4.65-dst

src/glpk-4.65: src/glpk-4.65.tar.gz
	mkdir -p src/glpk-4.65 && (cd src/glpk-4.65 && $(TAR) fxj ../glpk-4.65.tar.gz && mv */* . )
src/glpk-4.65.tar.gz:
	curl -L -o $@ 'http://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz'
glpk-4.65-darwin.17-x86_64.tar.gz: glpk-4.65-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
glpk-4.65: glpk-4.65-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
glpk: glpk-4.65

gmp-6.2.0-dst: src/gmp-6.2.0 
	rm -rf gmp-6.2.0-obj && mkdir gmp-6.2.0-obj && cd gmp-6.2.0-obj &&  ../src/gmp-6.2.0/configure --with-pic --disable-shared --enable-static ABI=64 && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/gmp-6.2.0-dst

src/gmp-6.2.0: src/gmp-6.2.0.tar.bz2
	mkdir -p src/gmp-6.2.0 && (cd src/gmp-6.2.0 && $(TAR) fxj ../gmp-6.2.0.tar.bz2 && mv */* . )
src/gmp-6.2.0.tar.bz2:
	curl -L -o $@ 'https://gmplib.org/download/gmp/gmp-6.2.0.tar.bz2'
gmp-6.2.0-darwin.17-x86_64.tar.gz: gmp-6.2.0-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
gmp-6.2.0: gmp-6.2.0-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
gmp: gmp-6.2.0

gsl-2.6-dst: src/gsl-2.6 
	rm -rf gsl-2.6-obj && mkdir gsl-2.6-obj && cd gsl-2.6-obj &&  ../src/gsl-2.6/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/gsl-2.6-dst

src/gsl-2.6: src/gsl-2.6.tar.gz
	mkdir -p src/gsl-2.6 && (cd src/gsl-2.6 && $(TAR) fxj ../gsl-2.6.tar.gz && mv */* . )
src/gsl-2.6.tar.gz:
	curl -L -o $@ 'https://ftp.gnu.org/gnu/gsl/gsl-2.6.tar.gz'
gsl-2.6-darwin.17-x86_64.tar.gz: gsl-2.6-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
gsl-2.6: gsl-2.6-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
gsl: gsl-2.6

hdf4-4.2.15-dst: src/hdf4-4.2.15 jpeg-9d szip-2.1.1
	rm -rf hdf4-4.2.15-obj && mkdir hdf4-4.2.15-obj && cd hdf4-4.2.15-obj &&  ../src/hdf4-4.2.15/configure --with-pic --disable-shared --enable-static --prefix=/usr/local --enable-build-mode=production --enable-hdf4-xdr --with-szip --disable-netcdf LIBS=-L/usr/local/lib && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/hdf4-4.2.15-dst

src/hdf4-4.2.15: src/hdf-4.2.15.tar.bz2
	mkdir -p src/hdf4-4.2.15 && (cd src/hdf4-4.2.15 && $(TAR) fxj ../hdf-4.2.15.tar.bz2 && mv */* . )
src/hdf-4.2.15.tar.bz2:
	curl -L -o $@ 'https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.15/src/hdf-4.2.15.tar.bz2'
hdf4-4.2.15-darwin.17-x86_64.tar.gz: hdf4-4.2.15-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
hdf4-4.2.15: hdf4-4.2.15-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
hdf4: hdf4-4.2.15

hdf5-1.12.0-dst: src/hdf5-1.12.0 szip-2.1.1 jpeg-9d
	rm -rf hdf5-1.12.0-obj && mkdir hdf5-1.12.0-obj && cd hdf5-1.12.0-obj &&  ../src/hdf5-1.12.0/configure --with-pic --disable-shared --enable-static --prefix=/usr/local --enable-build-mode=production --with-szlib && make -j12 && make install-recursive DESTDIR=/Volumes/Builds/recipes/build/hdf5-1.12.0-dst

src/hdf5-1.12.0: src/hdf5-1.12.0.tar.bz2
	mkdir -p src/hdf5-1.12.0 && (cd src/hdf5-1.12.0 && $(TAR) fxj ../hdf5-1.12.0.tar.bz2 && mv */* . )
src/hdf5-1.12.0.tar.bz2:
	curl -L -o $@ 'https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.bz2'
hdf5-1.12.0-darwin.17-x86_64.tar.gz: hdf5-1.12.0-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
hdf5-1.12.0: hdf5-1.12.0-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
hdf5: hdf5-1.12.0

icu-67.1-dst: src/icu-67.1 
	rm -rf icu-67.1-obj && mkdir icu-67.1-obj && cd icu-67.1-obj &&  ../src/icu-67.1/source/configure --with-pic --disable-shared --enable-static --disable-renaming && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/icu-67.1-dst

src/icu-67.1: src/icu4c-67_1-src.tgz
	mkdir -p src/icu-67.1 && (cd src/icu-67.1 && $(TAR) fxj ../icu4c-67_1-src.tgz && mv */* . )
src/icu4c-67_1-src.tgz:
	curl -L -o $@ 'https://github.com/unicode-org/icu/releases/download/release-67-1/icu4c-67_1-src.tgz'
icu-67.1-darwin.17-x86_64.tar.gz: icu-67.1-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
icu-67.1: icu-67.1-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
icu: icu-67.1

jpeg-9d-dst: src/jpeg-9d 
	rm -rf jpeg-9d-obj && mkdir jpeg-9d-obj && cd jpeg-9d-obj &&  ../src/jpeg-9d/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/jpeg-9d-dst

src/jpeg-9d: src/jpegsrc.v9d.tar.gz
	mkdir -p src/jpeg-9d && (cd src/jpeg-9d && $(TAR) fxj ../jpegsrc.v9d.tar.gz && mv */* . )
src/jpegsrc.v9d.tar.gz:
	curl -L -o $@ 'http://www.ijg.org/files/jpegsrc.v9d.tar.gz'
jpeg-9d-darwin.17-x86_64.tar.gz: jpeg-9d-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
jpeg-9d: jpeg-9d-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
jpeg: jpeg-9d

libpng-1.6.37-dst: src/libpng-1.6.37 
	rm -rf libpng-1.6.37-obj && mkdir libpng-1.6.37-obj && cd libpng-1.6.37-obj &&  ../src/libpng-1.6.37/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/libpng-1.6.37-dst

src/libpng-1.6.37: src/libpng-1.6.37.tar.xz
	mkdir -p src/libpng-1.6.37 && (cd src/libpng-1.6.37 && $(TAR) fxj ../libpng-1.6.37.tar.xz && mv */* . )
src/libpng-1.6.37.tar.xz:
	curl -L -o $@ 'https://downloads.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.xz'
libpng-1.6.37-darwin.17-x86_64.tar.gz: libpng-1.6.37-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
libpng-1.6.37: libpng-1.6.37-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
libpng: libpng-1.6.37

libpq-9.6.9-dst: src/libpq-9.6.9 
	rm -rf libpq-9.6.9-obj && mkdir libpq-9.6.9-obj && cd libpq-9.6.9-obj &&  ../src/libpq-9.6.9/configure --with-pic --disable-shared --enable-static CFLAGS=-fPIC && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/libpq-9.6.9-dst

src/libpq-9.6.9: src/postgresql-9.6.9.tar.bz2
	mkdir -p src/libpq-9.6.9 && (cd src/libpq-9.6.9 && $(TAR) fxj ../postgresql-9.6.9.tar.bz2 && mv */* . )
src/postgresql-9.6.9.tar.bz2:
	curl -L -o $@ 'https://ftp.postgresql.org/pub/source/v9.6.9/postgresql-9.6.9.tar.bz2'
libpq-9.6.9-darwin.17-x86_64.tar.gz: libpq-9.6.9-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local/pgsql/include/libpq-fe.h usr/local/pgsql/include/postgres_ext.h usr/local/pgsql/include/pg_config_ext.h usr/local/pgsql/lib/libpq.a
libpq-9.6.9: libpq-9.6.9-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
libpq: libpq-9.6.9

libsndfile-1.0.28-dst: src/libsndfile-1.0.28 
	rm -rf libsndfile-1.0.28-obj && mkdir libsndfile-1.0.28-obj && cd libsndfile-1.0.28-obj &&  ../src/libsndfile-1.0.28/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/libsndfile-1.0.28-dst

src/libsndfile-1.0.28: src/libsndfile-1.0.28.tar.gz
	mkdir -p src/libsndfile-1.0.28 && (cd src/libsndfile-1.0.28 && $(TAR) fxj ../libsndfile-1.0.28.tar.gz && mv */* . )
src/libsndfile-1.0.28.tar.gz:
	curl -L -o $@ 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.28.tar.gz'
libsndfile-1.0.28-darwin.17-x86_64.tar.gz: libsndfile-1.0.28-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
libsndfile-1.0.28: libsndfile-1.0.28-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
libsndfile: libsndfile-1.0.28

libwebp-1.1.0-dst: src/libwebp-1.1.0 libpng-1.6.37 jpeg-9d tiff-4.1.0
	rm -rf libwebp-1.1.0-obj && mkdir libwebp-1.1.0-obj && cd libwebp-1.1.0-obj &&  ../src/libwebp-1.1.0/configure --with-pic --disable-shared --enable-static LIBS=-lz && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/libwebp-1.1.0-dst

src/libwebp-1.1.0: src/libwebp-1.1.0.tar.gz
	mkdir -p src/libwebp-1.1.0 && (cd src/libwebp-1.1.0 && $(TAR) fxj ../libwebp-1.1.0.tar.gz && mv */* . )
src/libwebp-1.1.0.tar.gz:
	curl -L -o $@ 'https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz'
libwebp-1.1.0-darwin.17-x86_64.tar.gz: libwebp-1.1.0-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
libwebp-1.1.0: libwebp-1.1.0-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
libwebp: libwebp-1.1.0

mpfr-4.0.2-dst: src/mpfr-4.0.2 gmp-6.2.0
	rm -rf mpfr-4.0.2-obj && mkdir mpfr-4.0.2-obj && cd mpfr-4.0.2-obj &&  ../src/mpfr-4.0.2/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/mpfr-4.0.2-dst

src/mpfr-4.0.2: src/mpfr-4.0.2.tar.bz2
	mkdir -p src/mpfr-4.0.2 && (cd src/mpfr-4.0.2 && $(TAR) fxj ../mpfr-4.0.2.tar.bz2 && mv */* . )
src/mpfr-4.0.2.tar.bz2:
	curl -L -o $@ 'https://www.mpfr.org/mpfr-current/mpfr-4.0.2.tar.bz2'
mpfr-4.0.2-darwin.17-x86_64.tar.gz: mpfr-4.0.2-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
mpfr-4.0.2: mpfr-4.0.2-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
mpfr: mpfr-4.0.2

netcdf-4.7.4-dst: src/netcdf-4.7.4 hdf5-1.12.0 szip-2.1.1
	rm -rf netcdf-4.7.4-obj && mkdir netcdf-4.7.4-obj && cd netcdf-4.7.4-obj &&  ../src/netcdf-4.7.4/configure --with-pic --disable-shared --enable-static --enable-netcdf-4 --prefix=/usr/local LIBS=-lsz && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/netcdf-4.7.4-dst

src/netcdf-4.7.4: src/netcdf-c-4.7.4.tar.gz
	mkdir -p src/netcdf-4.7.4 && (cd src/netcdf-4.7.4 && $(TAR) fxj ../netcdf-c-4.7.4.tar.gz && mv */* . )
src/netcdf-c-4.7.4.tar.gz:
	curl -L -o $@ 'https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz'
netcdf-4.7.4-darwin.17-x86_64.tar.gz: netcdf-4.7.4-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
netcdf-4.7.4: netcdf-4.7.4-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
netcdf: netcdf-4.7.4

openjpeg-2.3.1-dst: src/openjpeg-2.3.1 
	rm -rf openjpeg-2.3.1-obj && mkdir openjpeg-2.3.1-obj && cd openjpeg-2.3.1-obj && sh ../src/openjpeg-2.3.1/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/openjpeg-2.3.1-dst

src/openjpeg-2.3.1: src/v2.3.1.tar.gz
	mkdir -p src/openjpeg-2.3.1 && (cd src/openjpeg-2.3.1 && $(TAR) fxj ../v2.3.1.tar.gz && mv */* . && patch -p1 < '/Volumes/Builds/recipes/recipes/openjpeg.patch')
src/v2.3.1.tar.gz:
	curl -L -o $@ 'https://github.com/uclouvain/openjpeg/archive/v2.3.1.tar.gz'
openjpeg-2.3.1-darwin.17-x86_64.tar.gz: openjpeg-2.3.1-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
openjpeg-2.3.1: openjpeg-2.3.1-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
openjpeg: openjpeg-2.3.1

openssl-1.1.1g-dst: src/openssl-1.1.1g 
	rm -rf openssl-1.1.1g-obj && mkdir openssl-1.1.1g-obj && cd openssl-1.1.1g-obj &&  ../src/openssl-1.1.1g/Configure no-shared --openssldir=/private/etc/ssl darwin64-x86_64-cc enable-ec_nistp_64_gcc_128 && make -j12 && make install_sw DESTDIR=/Volumes/Builds/recipes/build/openssl-1.1.1g-dst

src/openssl-1.1.1g: src/openssl-1.1.1g.tar.gz
	mkdir -p src/openssl-1.1.1g && (cd src/openssl-1.1.1g && $(TAR) fxj ../openssl-1.1.1g.tar.gz && mv */* . )
src/openssl-1.1.1g.tar.gz:
	curl -L -o $@ 'https://www.openssl.org/source/openssl-1.1.1g.tar.gz'
openssl-1.1.1g-darwin.17-x86_64.tar.gz: openssl-1.1.1g-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
openssl-1.1.1g: openssl-1.1.1g-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
openssl: openssl-1.1.1g

pcre-8.44-dst: src/pcre-8.44 
	rm -rf pcre-8.44-obj && mkdir pcre-8.44-obj && cd pcre-8.44-obj &&  ../src/pcre-8.44/configure --with-pic --disable-shared --enable-static --enable-unicode-properties && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/pcre-8.44-dst

src/pcre-8.44: src/pcre-8.44.tar.bz2
	mkdir -p src/pcre-8.44 && (cd src/pcre-8.44 && $(TAR) fxj ../pcre-8.44.tar.bz2 && mv */* . )
src/pcre-8.44.tar.bz2:
	curl -L -o $@ 'https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.bz2'
pcre-8.44-darwin.17-x86_64.tar.gz: pcre-8.44-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
pcre-8.44: pcre-8.44-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
pcre: pcre-8.44

pcre2-10.34-dst: src/pcre2-10.34 
	rm -rf pcre2-10.34-obj && mkdir pcre2-10.34-obj && cd pcre2-10.34-obj &&  ../src/pcre2-10.34/configure --with-pic --disable-shared --enable-static --disable-jit && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/pcre2-10.34-dst

src/pcre2-10.34: src/pcre2-10.34.tar.bz2
	mkdir -p src/pcre2-10.34 && (cd src/pcre2-10.34 && $(TAR) fxj ../pcre2-10.34.tar.bz2 && mv */* . )
src/pcre2-10.34.tar.bz2:
	curl -L -o $@ 'https://ftp.pcre.org/pub/pcre/pcre2-10.34.tar.bz2'
pcre2-10.34-darwin.17-x86_64.tar.gz: pcre2-10.34-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
pcre2-10.34: pcre2-10.34-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
pcre2: pcre2-10.34

pixman-0.38.4-dst: src/pixman-0.38.4 
	rm -rf pixman-0.38.4-obj && mkdir pixman-0.38.4-obj && cd pixman-0.38.4-obj &&  ../src/pixman-0.38.4/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/pixman-0.38.4-dst

src/pixman-0.38.4: src/pixman-0.38.4.tar.gz
	mkdir -p src/pixman-0.38.4 && (cd src/pixman-0.38.4 && $(TAR) fxj ../pixman-0.38.4.tar.gz && mv */* . )
src/pixman-0.38.4.tar.gz:
	curl -L -o $@ 'https://www.cairographics.org/releases/pixman-0.38.4.tar.gz'
pixman-0.38.4-darwin.17-x86_64.tar.gz: pixman-0.38.4-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
pixman-0.38.4: pixman-0.38.4-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
pixman: pixman-0.38.4

pkgconfig-0.28-dst: src/pkgconfig-0.28 
	rm -rf pkgconfig-0.28-obj && mkdir pkgconfig-0.28-obj && cd pkgconfig-0.28-obj &&  ../src/pkgconfig-0.28/configure --with-pic --disable-shared --enable-static --with-internal-glib && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/pkgconfig-0.28-dst

src/pkgconfig-0.28: src/pkg-config-0.28.tar.gz
	mkdir -p src/pkgconfig-0.28 && (cd src/pkgconfig-0.28 && $(TAR) fxj ../pkg-config-0.28.tar.gz && mv */* . )
src/pkg-config-0.28.tar.gz:
	curl -L -o $@ 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz'
pkgconfig-0.28-darwin.17-x86_64.tar.gz: pkgconfig-0.28-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
pkgconfig-0.28: pkgconfig-0.28-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
pkgconfig: pkgconfig-0.28

proj-6.3.1-dst: src/proj-6.3.1 
	rm -rf proj-6.3.1-obj && mkdir proj-6.3.1-obj && cd proj-6.3.1-obj &&  ../src/proj-6.3.1/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/proj-6.3.1-dst

src/proj-6.3.1: src/proj-6.3.1.tar.gz
	mkdir -p src/proj-6.3.1 && (cd src/proj-6.3.1 && $(TAR) fxj ../proj-6.3.1.tar.gz && mv */* . )
src/proj-6.3.1.tar.gz:
	curl -L -o $@ 'https://download.osgeo.org/proj/proj-6.3.1.tar.gz'
proj-6.3.1-darwin.17-x86_64.tar.gz: proj-6.3.1-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
proj-6.3.1: proj-6.3.1-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
proj: proj-6.3.1

protobuf-3.11.4-dst: src/protobuf-3.11.4 
	rm -rf protobuf-3.11.4-obj && mkdir protobuf-3.11.4-obj && cd protobuf-3.11.4-obj &&  ../src/protobuf-3.11.4/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/protobuf-3.11.4-dst

src/protobuf-3.11.4: src/protobuf-cpp-3.11.4.tar.gz
	mkdir -p src/protobuf-3.11.4 && (cd src/protobuf-3.11.4 && $(TAR) fxj ../protobuf-cpp-3.11.4.tar.gz && mv */* . )
src/protobuf-cpp-3.11.4.tar.gz:
	curl -L -o $@ 'https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protobuf-cpp-3.11.4.tar.gz'
protobuf-3.11.4-darwin.17-x86_64.tar.gz: protobuf-3.11.4-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
protobuf-3.11.4: protobuf-3.11.4-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
protobuf: protobuf-3.11.4

qpdf-9.1.1-dst: src/qpdf-9.1.1 jpeg-9d
	rm -rf qpdf-9.1.1-obj && rsync -a src/qpdf-9.1.1/ qpdf-9.1.1-obj/ && cd qpdf-9.1.1-obj &&  ./configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/qpdf-9.1.1-dst

src/qpdf-9.1.1: src/qpdf-9.1.1.tar.gz
	mkdir -p src/qpdf-9.1.1 && (cd src/qpdf-9.1.1 && $(TAR) fxj ../qpdf-9.1.1.tar.gz && mv */* . )
src/qpdf-9.1.1.tar.gz:
	curl -L -o $@ 'https://downloads.sourceforge.net/project/qpdf/qpdf/9.1.1/qpdf-9.1.1.tar.gz'
qpdf-9.1.1-darwin.17-x86_64.tar.gz: qpdf-9.1.1-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
qpdf-9.1.1: qpdf-9.1.1-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
qpdf: qpdf-9.1.1

sigc++-2.10.3-dst: src/sigc++-2.10.3 
	rm -rf sigc++-2.10.3-obj && mkdir sigc++-2.10.3-obj && cd sigc++-2.10.3-obj &&  ../src/sigc++-2.10.3/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/sigc++-2.10.3-dst

src/sigc++-2.10.3: src/libsigc++-2.10.3.tar.xz
	mkdir -p src/sigc++-2.10.3 && (cd src/sigc++-2.10.3 && $(TAR) fxj ../libsigc++-2.10.3.tar.xz && mv */* . )
src/libsigc++-2.10.3.tar.xz:
	curl -L -o $@ 'http://ftp.acc.umu.se/pub/GNOME/sources/libsigc++/2.10/libsigc++-2.10.3.tar.xz'
sigc++-2.10.3-darwin.17-x86_64.tar.gz: sigc++-2.10.3-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
sigc++-2.10.3: sigc++-2.10.3-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
sigc++: sigc++-2.10.3

sqlite3-3.32.3-dst: src/sqlite3-3.32.3 
	rm -rf sqlite3-3.32.3-obj && mkdir sqlite3-3.32.3-obj && cd sqlite3-3.32.3-obj &&  ../src/sqlite3-3.32.3/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/sqlite3-3.32.3-dst

src/sqlite3-3.32.3: src/sqlite-autoconf-3320300.tar.gz
	mkdir -p src/sqlite3-3.32.3 && (cd src/sqlite3-3.32.3 && $(TAR) fxj ../sqlite-autoconf-3320300.tar.gz && mv */* . )
src/sqlite-autoconf-3320300.tar.gz:
	curl -L -o $@ 'https://www.sqlite.org/2020/sqlite-autoconf-3320300.tar.gz'
sqlite3-3.32.3-darwin.17-x86_64.tar.gz: sqlite3-3.32.3-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
sqlite3-3.32.3: sqlite3-3.32.3-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
sqlite3: sqlite3-3.32.3

szip-2.1.1-dst: src/szip-2.1.1 
	rm -rf szip-2.1.1-obj && mkdir szip-2.1.1-obj && cd szip-2.1.1-obj &&  ../src/szip-2.1.1/configure --with-pic --disable-shared --enable-static --prefix=/usr/local && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/szip-2.1.1-dst

src/szip-2.1.1: src/szip-2.1.1.tar.gz
	mkdir -p src/szip-2.1.1 && (cd src/szip-2.1.1 && $(TAR) fxj ../szip-2.1.1.tar.gz && mv */* . )
src/szip-2.1.1.tar.gz:
	curl -L -o $@ 'https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz'
szip-2.1.1-darwin.17-x86_64.tar.gz: szip-2.1.1-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
szip-2.1.1: szip-2.1.1-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
szip: szip-2.1.1

texinfo-6.7-dst: src/texinfo-6.7 
	rm -rf texinfo-6.7-obj && mkdir texinfo-6.7-obj && cd texinfo-6.7-obj &&  ../src/texinfo-6.7/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/texinfo-6.7-dst

src/texinfo-6.7: src/texinfo-6.7.tar.gz
	mkdir -p src/texinfo-6.7 && (cd src/texinfo-6.7 && $(TAR) fxj ../texinfo-6.7.tar.gz && mv */* . )
src/texinfo-6.7.tar.gz:
	curl -L -o $@ 'https://ftp.gnu.org/gnu/texinfo/texinfo-6.7.tar.gz'
texinfo-6.7-darwin.17-x86_64.tar.gz: texinfo-6.7-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
texinfo-6.7: texinfo-6.7-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
texinfo: texinfo-6.7

tiff-4.1.0-dst: src/tiff-4.1.0 jpeg-9d xz-5.2.4
	rm -rf tiff-4.1.0-obj && mkdir tiff-4.1.0-obj && cd tiff-4.1.0-obj &&  ../src/tiff-4.1.0/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/tiff-4.1.0-dst

src/tiff-4.1.0: src/tiff-4.1.0.tar.gz
	mkdir -p src/tiff-4.1.0 && (cd src/tiff-4.1.0 && $(TAR) fxj ../tiff-4.1.0.tar.gz && mv */* . )
src/tiff-4.1.0.tar.gz:
	curl -L -o $@ 'http://download.osgeo.org/libtiff/tiff-4.1.0.tar.gz'
tiff-4.1.0-darwin.17-x86_64.tar.gz: tiff-4.1.0-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
tiff-4.1.0: tiff-4.1.0-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
tiff: tiff-4.1.0

udunits-2.2.24-dst: src/udunits-2.2.24 
	rm -rf udunits-2.2.24-obj && mkdir udunits-2.2.24-obj && cd udunits-2.2.24-obj &&  ../src/udunits-2.2.24/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/udunits-2.2.24-dst

src/udunits-2.2.24: src/udunits-2.2.24.tar.gz
	mkdir -p src/udunits-2.2.24 && (cd src/udunits-2.2.24 && $(TAR) fxj ../udunits-2.2.24.tar.gz && mv */* . )
src/udunits-2.2.24.tar.gz:
	curl -L -o $@ 'ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.24.tar.gz'
udunits-2.2.24-darwin.17-x86_64.tar.gz: udunits-2.2.24-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
udunits-2.2.24: udunits-2.2.24-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
udunits: udunits-2.2.24

xml2-2.9.10-dst: src/xml2-2.9.10 xz-5.2.4
	rm -rf xml2-2.9.10-obj && mkdir xml2-2.9.10-obj && cd xml2-2.9.10-obj &&  ../src/xml2-2.9.10/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/xml2-2.9.10-dst

src/xml2-2.9.10: src/libxml2-2.9.10.tar.gz
	mkdir -p src/xml2-2.9.10 && (cd src/xml2-2.9.10 && $(TAR) fxj ../libxml2-2.9.10.tar.gz && mv */* . )
src/libxml2-2.9.10.tar.gz:
	curl -L -o $@ 'ftp://xmlsoft.org/libxml2/libxml2-2.9.10.tar.gz'
xml2-2.9.10-darwin.17-x86_64.tar.gz: xml2-2.9.10-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
xml2-2.9.10: xml2-2.9.10-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
xml2: xml2-2.9.10

xz-5.2.4-dst: src/xz-5.2.4 
	rm -rf xz-5.2.4-obj && mkdir xz-5.2.4-obj && cd xz-5.2.4-obj &&  ../src/xz-5.2.4/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/xz-5.2.4-dst

src/xz-5.2.4: src/xz-5.2.4.tar.bz2
	mkdir -p src/xz-5.2.4 && (cd src/xz-5.2.4 && $(TAR) fxj ../xz-5.2.4.tar.bz2 && mv */* . )
src/xz-5.2.4.tar.bz2:
	curl -L -o $@ 'http://tukaani.org/xz/xz-5.2.4.tar.bz2'
xz-5.2.4-darwin.17-x86_64.tar.gz: xz-5.2.4-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
xz-5.2.4: xz-5.2.4-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
xz: xz-5.2.4

zeromq-4.3.2-dst: src/zeromq-4.3.2 
	rm -rf zeromq-4.3.2-obj && mkdir zeromq-4.3.2-obj && cd zeromq-4.3.2-obj &&  ../src/zeromq-4.3.2/configure --with-pic --disable-shared --enable-static && make -j12 && make install DESTDIR=/Volumes/Builds/recipes/build/zeromq-4.3.2-dst

src/zeromq-4.3.2: src/zeromq-4.3.2.tar.gz
	mkdir -p src/zeromq-4.3.2 && (cd src/zeromq-4.3.2 && $(TAR) fxj ../zeromq-4.3.2.tar.gz && mv */* . )
src/zeromq-4.3.2.tar.gz:
	curl -L -o $@ 'https://github.com/zeromq/libzmq/releases/download/v4.3.2/zeromq-4.3.2.tar.gz'
zeromq-4.3.2-darwin.17-x86_64.tar.gz: zeromq-4.3.2-dst
	sudo chown -Rh 0:0 '$^'
	tar fcz '$@' -C '$^' usr/local
zeromq-4.3.2: zeromq-4.3.2-darwin.17-x86_64.tar.gz
	sudo $(TAR) fxz '$^' -C /usr/local --strip 2 && touch '$@'
zeromq: zeromq-4.3.2



all: QuantLib-1.18 bdb-6.2.23 boost-1.73.0 cairo-1.14.12 cairomm-1.11.2 ffi-3.3 fftw-3.3.8 fontconfig-2.13.1 freetype-2.10.0 freexl-1.0.6 gdal-3.1.4 geos-3.8.1 glpk-4.65 gmp-6.2.0 gsl-2.6 hdf4-4.2.15 hdf5-1.12.0 icu-67.1 jpeg-9d libpng-1.6.37 libpq-9.6.9 libsndfile-1.0.28 libwebp-1.1.0 mpfr-4.0.2 netcdf-4.7.4 openjpeg-2.3.1 openssl-1.1.1g pcre-8.44 pcre2-10.34 pixman-0.38.4 pkgconfig-0.28 proj-6.3.1 protobuf-3.11.4 qpdf-9.1.1 sigc++-2.10.3 sqlite3-3.32.3 szip-2.1.1 texinfo-6.7 tiff-4.1.0 udunits-2.2.24 xml2-2.9.10 xz-5.2.4 zeromq-4.3.2

