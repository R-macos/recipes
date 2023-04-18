## Tcl/Tk Build Scripts

This directory contains build scripts used to build Tcl/Tk X11
binaries as shipped with the CRAN builds of R. They are not included in
recipes (yet), partially because they require special setup which
does not include any libraries from recipes, but instead uses XQuartz
dynamic libraries to avoid conflicts.

The scripts will build for `/opt/R/<arch>` location (where
_`<arch>`_ is either `arm64` or `x86_64` depending on the machine) using
X11 build of Tk linked against XQuartz with Xft support. Each script
generates one tar ball, there are separate scripts for Tcl, Tk and
TkTable and must be run in that order. The resulting tree (as expected
by the <tt>aux.sh</tt> script in the R4 packaging system) is created
by simply unpacking all three tar balls into the <tt>tcltk-8.6</tt>
directory of the packaging system.

--
Last updated: 2022-04-18 by Simon Urbanek
