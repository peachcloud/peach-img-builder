#!/usr/bin/env bash
WD=/home/notplants/computer/projects/peachcloud/image-specs
cd $WD/vmdb2
sudo ./vmdb2 --verbose --rootfs-tarball=$WD/my_raspi.tar.gz --output $WD/my_raspi.img $WD/raspi_3.yaml --log $WD/my_raspi.log

