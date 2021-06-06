## CRAN setup notes

This document decribes the CRAN-specific settings used to build the libraries using recipes, distributed at https://mac.R-project.org and used to build R and packages binaries on CRAN.

### High Sierra x86_64 build

This build uses default settings to install to `/usr/local` and `sudo` to adjust permissions. It is recommended to set compilers to `clang` (i.e., `CC=clang`, `CXX=clsang++` etc.), but most libraries don't care as Xcode has symlinks from `gcc` to `clang`.

Binaries in https://mac.R-project.org/libs-4/

### Big Sur arm64 build

This build uses non-standard location (`/opt/R/arm64`) to avoid clases with the libraries in `/usr/local` which often come from legacy Intel builds. Therefore the following settings are used to guarantee single-arch arm64 builds of the libraries which can co-exist with x86_64 binaries:

```
NOSUDO=1 PREFIX=opt/R/arm64 \
/Library/Frameworks/R.framework/Resources/bin/Rscript scripts/mkmk.R 

NOSUDO=1 PREFIX=opt/R/arm64 PATH=/opt/R/arm64/bin:$PATH \
PKG_CONFIG_PATH=/opt/R/arm64/lib/pkgconfig:/usr/lib/pkgconfig \
CC='clang -arch arm64' CXX='clang++ -arch arm64' \
OBJC='clang -arch arm64' OBJCXX='clang++ -arch arm64' \
CPPFLAGS=-I/opt/R/arm64/include \
LDFLAGS=-L/opt/R/arm64/lib \
make -C build all
```

Note that `/opt/R/arm64` is expected to exist and be writable by the user as the above does not use `sudo` to adjust permissions.

Binaries in https://mac.R-project.org/libs-arm64/
