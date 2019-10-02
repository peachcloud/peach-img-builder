# Raspberry Pi image specs

This repository contains the files with which the images referenced at
https://wiki.debian.org/RaspberryPiImages have been built.

## Option 1: Downloading an image

See https://wiki.debian.org/RaspberryPiImages for where to obtain the
latest pre-built image.

## Option 2: Building your own image

If you prefer, you can build a Debian buster Raspberry Pi image
yourself. If you are reading this document online, you should first
clone this repository:

```shell
git clone --recursive https://salsa.debian.org/raspi-team/image-specs.git
cd image-specs
```

For this you will first need to install the `vmdb2` package, on a
Debian Buster or higher system.

The recipes for building the images are:

- [raspi0w.yaml](raspi0w.yaml) for Raspberry Pi 0 and 0w. We believe
  (but have not tested) it should also work on the 1 models.
- [raspi2.yaml](raspi2.yaml) for Raspberry Pi 2.
- [raspi3.yaml](raspi3.yaml) for all of the Raspberry Pi 3 models.

You can edit them to customize the built image. Although it could
(should!) be better documented,
[vmdb2](http://git.liw.fi/vmdb2/tree/README)'s format is very easy to
understand.

Once you have edited the recipe for your hardware, you can generate
the image by issuing the following (as root):

```shell
    ./vmdb2/vmdb2 --rootfs-tarball=raspi3.tar.gz --output \
	raspi3.img raspi3.yaml --log raspi3.log
```

Of course, substituting `raspi3` with the actual flavor you need.

## Installing the image onto the Raspberry Pi

Plug an SD card which you would like to entirely overwrite into your SD card reader.

Assuming your SD card reader provides the device `/dev/mmcblk0`
(**Beware** If you choose the wrong device, you might overwrite
important parts of your system.  Double check it's the correct
device!), copy the image onto the SD card:

```shell
sudo dd if=raspi3.img of=/dev/mmcblk0 bs=64k oflag=dsync status=progress
```

Then, plug the SD card into the Raspberry Pi, and power it up.

The image uses the hostname `rpi0w`, `rpi2` or `rpi3` depending on the
target build, so assuming your local network correctly resolves
hostnames communicated via DHCP, you can log into your Raspberry Pi
once it booted:

```shell
ssh root@rpi3
# Enter password “raspberry”
```

Note that the default firewall rules only allow SSH access from the local
network. If you wish to enable SSH access globally, first change your root
password using `passwd`. Next, issue the following commands as root to remove
the corresponding firewall rules:

```shell
iptables -F INPUT
ip6tables -F INPUT
```

This will allow SSH connections globally until the next reboot. To make this
persistent, remove the lines containing "REJECT" in `/etc/iptables/rules.v4` and
`/etc/iptables/rules.v6`.

