#!/usr/bin/env bash
# remove old files
rm -f raspi_3.img
rm -f raspi_3.img.xz
rm -f raspi_3.log
rm -f peach-img-manifest.log

# build image
make raspi_3.img

mv raspi_3.img ~/computer/projects/peachcloud/debian_base.img
# compress image
echo "++ successful image build of debian base"
