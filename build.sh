#!/usr/bin/env bash
rm -f raspi_3.img
rm -f raspi_3.log
make raspi_3.img

# copy to releases
TODAY=$(date +"%Y%m%d")
RELEASE_DIR=/var/www/releases.peachcloud.org/html/peach-imgs/$TODAY
echo "++ successful image build, copying output to ${RELEASE_DIR}"
mkdir -p $RELEASE_DIR
cp raspi_3.img $RELEASE_DIR/${TODAY}_peach_raspi3.img
cp raspi_3.log $RELEASE_DIR/${TODAY}_peach_raspi3.log