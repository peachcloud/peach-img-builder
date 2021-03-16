#!/usr/bin/env bash
# remove old files
rm -f raspi_3.img
rm -f raspi_3.img.xz
rm -f raspi_3.log
rm -f peach-img-manifest.log

# build image
make raspi_3.img

# compress image
echo "++ successful image build, performing compression"
xz -k raspi_3.img

# make releases dir
TODAY=$(date +"%Y%m%d")
RELEASE_DIR=/var/www/releases.peachcloud.org/html/peach-imgs/$TODAY
echo "++ copy output to ${RELEASE_DIR}"
mkdir -p $RELEASE_DIR

# copy over files
cp raspi_3.img.xz $RELEASE_DIR/${TODAY}_peach_raspi3.img.xz
cp raspi_3.log $RELEASE_DIR/${TODAY}_peach_raspi3.log
cp peach-img-manifest.log $RELEASE_DIR/${TODAY}_peach_manifest.log

# publish image to releases.peachcloud.org
python3 publish_img.py $RELEASE_DIR