#!/usr/bin/env bash

# turn on verbose debugging output for parabuild logs.
exec 4>&1; export BASH_XTRACEFD=4; set -x
# make errors fatal
set -e
# complain about unset env variables
set -u

# check autobuild is around or fail
if [ -z "$AUTOBUILD" ] ; then
    exit 1
fi

if [ "$OSTYPE" = "cygwin" ] ; then
    autobuild="$(cygpath -u $AUTOBUILD)"
else
    autobuild="$AUTOBUILD"
fi

STAGING_DIR="$(pwd)"
TOP_DIR="$(dirname "$0")"
SRC_DIR="${TOP_DIR}/src"

# load autobuild provided shell functions and variables
source_environment_tempfile="$STAGING_DIR/source_environment.sh"
"$autobuild" source_environment > "$source_environment_tempfile"
. "$source_environment_tempfile"

LICENSE_DIR="${STAGING_DIR}/LICENSES"
test -d ${LICENSE_DIR} || mkdir ${LICENSE_DIR}
echo "See <FontName>-license.txt for each individual font's license" > "${LICENSE_DIR}/fonts.txt"

fonts_version=1
build=${AUTOBUILD_BUILD_ID:=0}
echo "${fonts_version}.${build}" > "${STAGING_DIR}/VERSION.txt"

FONTS_DIR="${STAGING_DIR}/fonts"
test -d ${FONTS_DIR} || mkdir ${FONTS_DIR}

cp -v "${SRC_DIR}"/*.ttf         "${FONTS_DIR}"
cp -v "${SRC_DIR}"/*-license.txt "${LICENSE_DIR}"
