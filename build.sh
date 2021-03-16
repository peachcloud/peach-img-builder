#!/usr/bin/env bash
rm -f raspi_3.img
rm -f raspi_3.log
make raspi_3.img

# copy to releases
TODAY=$(date +"%Y%m%d")
RELEASE_DIR=/var/www/releases.peachcloud.org/html/peach-imgs/$TODAY
mkdir -p $RELEASE_DIR
echo "++ successful image build, performing compression"
xz -k raspi.img
status=$?
if [ $status -eq 0  ]; then
    echo "++ compression successful, copying compressed img to ${RELEASE_DIR}"
    cp raspi_3.img.xz $RELEASE_DIR/${TODAY}_peach_raspi3.img.xz
else
    echo "++ compression failed, copying uncompressed img to ${RELEASE_DIR}"
    cp raspi_3.img $RELEASE_DIR/${TODAY}_peach_raspi3.img
fi
cp raspi_3.log $RELEASE_DIR/${TODAY}_peach_raspi3.log
