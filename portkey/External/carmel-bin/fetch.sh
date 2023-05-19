#!/bin/bash

if [ "x${TARGET_PLATFORM}" = "x" ]; then
	TARGET_PLATFORM="ios"
fi
BIN_DIR="carmel-${TARGET_PLATFORM}"

FILENAME="libcarmel.tar.xz"
FILENAME_FULL="${BIN_DIR}/${FILENAME}"
MD5="`cat ${TARGET_PLATFORM}/MD5`"
URL="`cat ${TARGET_PLATFORM}/URL`"

MD5EXE=`which md5`
if [ "x${MD5EXE}" = "x" ]; then
  MD5EXE=`which md5sum`
else
  MD5EXE="${MD5EXE} -q"
fi

CALCMD5=`${MD5EXE} ${FILENAME_FULL} | cut -d ' ' -f1`
if [ "x${CALCMD5}" = "x${MD5}" ]; then
  echo "Versions match; not doing anything"
  exit
fi

rm -rf ${BIN_DIR}
mkdir -p ${BIN_DIR}
pushd ${BIN_DIR}
wget -O ${FILENAME} ${URL}
if [ $? -ne 0 ]; then
  echo "Error downloading file!"
  exit 1
fi
popd

CALCMD5=`${MD5EXE} ${FILENAME_FULL} | cut -d ' ' -f1`
if [ "x${CALCMD5}" != "x${MD5}" ]; then
  echo "WARNING: MD5 does not match!"
  exit 1
fi

xzcat ${FILENAME_FULL} | tar xvf - -C ${BIN_DIR}
