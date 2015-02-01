## Recipes

This is an experimental system for building static, dependent libraries
for R packages. It is mainly intended to automate the maintenance of
CRAN dependencies for the OS X build system, but the system is intended
to be usable on other platforms as well.

The idea is for package authors to submit pull requests for
dependencies their packages require such that they can be
automatically installed on the build VMs.

The dependency descriptions are simple DCF files. So far this
repository only contains a few test description files for the most
basic libraries required by R and some packages. Eventually it will
contain the build system itself as well.

