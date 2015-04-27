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

    Rscript scripts/mkmk.R && cd builds && make all

Use a recipe name instead of `all` to build a specific library and its
dependencies. Each library is built, packaged and installed.
