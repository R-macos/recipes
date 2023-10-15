#!/bin/bash
# This is a small wrapper that makes simple Makefile work in autoconf setting
# (C)2022 Simon Urbanek, License: MIT
#
# Special arguments:
# --prefix=<prefix> => prefix=/<prefix>
# --target=<target> specifies the build target (empty by default)
# --install=<target> specifies the install target ('install' by default)
# --set=<...> defines explicit make argument/variable (needed to
#     distinguish FOO=bar env var from FOO=bar make var (as --set=FOO=bar).
# Any arguments of the form XXX=YY will be converted to
# environment variables. Any other arguments are passed to make.

BD="`pwd`"
SD="`dirname $0`"
SD="`(cd $SD && pwd)`"

default_target=''
install_target=install

echo Collecting env vars from arguments:
while (( "$#" )); do
    if echo "$1" | grep -E '^[A-Z]+=' >/dev/null; then
	export "$1"
	echo "  $1"
    else
	case "$1" in
	    --prefix=*)
		PREFIX=`echo $1 | sed 's:^--prefix=/*::'`
		echo " prefix=/$PREFIX"
		MARGS+=("prefix=/$PREFIX")
		;;
	    --target=*)
		default_target=`echo $1 | sed 's:^--target=::'`
		echo " (default build target: ${default_target})"
		;;
	    --install=*)
		install_target=`echo $1 | sed 's:^install=::'`
		echo " (install target: ${default_target})"
		;;
	    --set=*)
		MARGS+=("`echo $1 | sed 's:^--set=::'`")
		;;
	    *)
		MARGS+=("$1")
		;;
	esac
    fi
    shift
done

echo "Build args: ${MARGS[@]} ${default_target}"
echo "Install args: ${install_target} DESTDIR=\$(DESTDIR) ${MARGS[@]}"

echo Copying sources ...
cp -p -R "${SD}/" .

mv "$BD/Makefile" "$BD/Makefile.real"

cat > "$BD/Makefile" << EOF
all:
	make -f Makefile.real ${MARGS[@]} ${default_target}

install:
	make -f Makefile.real ${install_target} DESTDIR=\$(DESTDIR) ${MARGS[@]}

.PHONY: all install

EOF

echo "Makefile generated."
