## Recipes

This is an experimental system for building static, dependent libraries
for R packages. It is mainly intended to automate the maintenance of
CRAN dependencies for the OS X build system, but the system is intended
to be usable on other platforms as well.

The idea is for package authors to submit pull requests for
dependencies their packages require such that they can be
automatically installed on the build VMs.

The dependency descriptions are simple DCF files. The format should be
self-explanatory, it follows the same conventions as `DESCRIPTION`
files in R packages. The required fields are `Package`, `Version` and
`Source.URL`. Most common optional fields include `Depends` and
`Configure`.

There is an R script that will process the recipes and create a make
file which can be used to build libraries and their dependencies.
For example, to build all libraries and their dependencies:

    Rscript scripts/mkmk.R && cd build && make all

Use a recipe name instead of `all` to build a specific library and its
dependencies. Each library is built, packaged and installed.

### Reference

 * `Configure[.<os>[.<ver>]][.<arch>]:` flags to add to the `configure`
   script. `<os>` is the lowecase name of the OS as returned by
   `uname`, `<ver>` is the major version of the OS (`uname -r` up
   to the first dot) and `<arch>` is the architecture of the
   platform. Multiple types can be specified and they are concatenated
   using precedence `os, ver, arch`.

 * `Depends:` list of dependent recipes

 * `Package:` name of the package (required)

 * `Version:` version of the package (required)

 * `Source.URL:` URL of the source tar ball (required)

 * `Configure.subdir:` subdirectory containing the sources

 * `Special:` special recipe flags, currently only `in-sources` is
   supported which forces the build to be performed inside the
   sources.

 * `Distribution.files:` list of files (or directories) to include
   in the final distribution tar ball. Defaults to `usr/local`.
   This directive is intended only for restricting the content,
   installation is only supported for content under `usr/local`
   so no files outside that tree can be part of  the final
   distribution.

 * `Configure.script:` name of the configure script to use,
   defaults to `configure`

 * `Configure.driver:` optional, if set, specifies the executable
   that will be called in order to process the configure script.
   If not specified it is assumed that the configure script is
   executable on its own.


### Building

Currently the build steps are

 * download source tar ball
 * unpack the tar ball
 * move the contents to a directory with fixed naming scheme
 * if a `<recipe>.patch` file exists, it will be applied with -p1
 * create a build object directory
 * configure in the object directory using all the accumulated flags
   from the recipe
 * run `make -j12`
 * run `make install` with `DESTDIR` set
 * change the ownership of content instide `DESTDIR` to 0:0
 * package `usr` inside the destination into a tar ball
 * unpack the tar ball in the system location

Each dependency has to succeed in all the steps above before the next
recipe is used. Makefile is used to determine the dependencies between
the recipes.

Note: currently `pkgconfig` is not specifically listed in most recipes
even though several of them use it, so it is advisable to use `make
pkgconfig` before using `make all`.

### Environment Variables

The `mkmk.R` script will respect the following environment variables:

 * `TAR` path to the `tar` program. Note that the build system assumes
   a tar version that is smart enough to handle all common compression
   formats (`gzip`, `bzip2`, `xz`) automatically.
