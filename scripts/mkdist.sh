#!/bin/sh

set -e

if [ ! -e "build" ]; then
   echo "ERROR: Plase run this script in the project root." >&2
   exit 1
fi

DST="$1"
if [ -z "$DST" ]; then DST=dist; fi

if [ ! -e "$DST" ]; then mkdir -p "$DST"; fi

rm -f "$DST/PACKAGES"
touch "$DST/PACKAGES"

for tar in `ls build/*.tar.gz`; do
   n=`echo $tar | sed -e 's:-darwin.*.tar.gz$::' -e 's:.*/::'`   
   echo $n
   cp -p $tar build/$n "$DST"
   cat build/$n >> "$DST/PACKAGES"
done
