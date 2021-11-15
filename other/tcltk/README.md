## Tcl/Tk Build Scripts

This directory contains build scripts used to build Tcl/Tk X11
binaries as shipped with arm64 builds of R. They are not included in
recipes (yet), partially because they require special setup which
does not include any libraries from recipes, but instead uses XQuartz
dynamic libraries to avoid conflicts.

The scripts will build for <tt>/opt/R/&lt;arch&gt;</tt> location using
X11 build of Tk linked against XQuartz with Xft support. Each script
generates one tar ball, there are separate scripts for Tcl, Tk and
TkTable and must be run in that order. The resulting tree (as expected
by the <tt>aux.sh</tt> script in the R4 packaging system) is created
by simply unpacking all three tar balls into the <tt>tcltk-8.6</tt>
directory of the packaging system.

--
Last updated: 2021-11-16 by Simon Urbanek
