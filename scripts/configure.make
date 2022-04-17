#!/bin/bash
# This is a small wrapper that makes simple Makefile work in autoconf setting
# (C)2022 Simon Urbanek, License: MIT

BD="`pwd`"
SD="`dirname $0`"
SD="`(cd $SD && pwd)`"

echo Collecting env vars from arguments:
while (( "$#" )); do
    if echo "$1" | grep -E '^[A-Z]+=' >/dev/null; then
	export "$1"
	echo "  $1"
    else
	if echo "$1" | grep '^--prefix='; then
	    PREFIX=`echo $1 | sed 's:^--prefix=/*::'`
	    MARGS+=("prefix=/$PREFIX")
	else
	    MARGS+=("$1")
	fi
    fi
    shift
done

echo Copying sources ...
cp -p -R "${SD}/" .

mv "$BD/Makefile" "$BD/Makefile.real"

cat > "$BD/Makefile" << EOF
all:
	make -f Makefile.real $MARGS

install:
	make -f Makefile.real install DESTDIR=\$(DESTDIR) $MARGS

EOF

echo "Makefile generated."
