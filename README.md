⚠️ This repo is no longer active and has been archived. The active repo can be found at https://git.coopcloud.tech/PeachCloud/peach-img-builder ⚠️

-----

This is a fork of the [vmdb2 script](https://salsa.debian.org/raspi-team/image-specs/-/tree/master) for building a [debian image for raspberry pi](https://wiki.debian.org/RaspberryPi),
which uses vmdb2 to build  a disc image for PeachCloud
for the Raspberry pi with all configuration and peach microservices pre-installed.

This vmdb2 script creates a working Debian image, 
adds apt.peachcloud.org as an apt source,
and then uses peach-config to install all PeachCloud microservices.


## Installing vmdb2

Run,
```shell
sudo apt install -y dosfstools qemu-user-static binfmt-support time kpartx
```

This script requires the latest version of vmdb2 which is not currently available via apt. 
After installing the above, clone the vmdb2 repository and add it to your path. 
```shell
git clone https://gitlab.com/larswirzenius/vmdb2.git
cd vmdb2; ln -s ${PWD}/vmdb2 /usr/local/bin/vmdb2
```

## To Build A New Image

Run,
```shell
make raspi_3.img
```

Theoretically, you could also use this script to build images for other pi versions, 
by running the same command with `raspi_0w.img` or `raspi_2.img` or `raspi_3.img`


## Installing The Image

This image can then be flashed to an SD card using dd or etcher. 


## Publishing The Image

To build a new peach image, and copy the output image and log to the releases directory, run:
```shell
./build.sh
```

PeachCloud images are versioned and published for release at http://releases.peachcloud.org/


## What's Different In This Fork?

the only file that is edited from the original is ```raspi_master.yaml```


## Image Size

Note that the alloted disc image size in the original image was 1500M. 
This is not large enough to allow for the whole peach installation, 
so this image is currently at 2000M.

On first boot, the image resizes to take up the whole size of the SD card it is installed on.
