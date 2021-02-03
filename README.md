This is a fork of the [vmdb2 script](https://salsa.debian.org/raspi-team/image-specs/-/tree/master) for building a [debian image for raspberry pi](https://wiki.debian.org/RaspberryPi),
which uses vmdb2 to build  a disc image for PeachCloud
for the Raspberry pi with all configuration and peach microservices pre-installed.

This vmdb2 script runs:
`python setup_dev_env.py -i -n peach`,
the python setup script from [peach-config](https://github.com/peachcloud/peach-config).

# Installing vmdb2

Run,
```shell
sudo apt install -y vmdb2 dosfstools qemu-user-static binfmt-support time kpartx
```

# To Build A New Image

Run,
```shell
make raspi_3.img
```

Theoretically, you could also use this script to build images for other pi versions, 
by running the same command with `raspi_0w.img` or `raspi_2.img` or `raspi_3.img`


# Installing The Image

This image can then be flashed to an SD card using dd or etcher. 


# Publishing The Image

PeachCloud images are versioned and published for release at http://releases.peachcloud.org/