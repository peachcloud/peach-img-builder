yaml: raspi_0w.yaml raspi_2.yaml raspi_3.yaml
images: raspi_0w.img raspi_2.img raspi_3.img

raspi_0w.yaml: raspi_master.yaml
	cat raspi_master.yaml | sed "s/__ARCH__/armel/" | \
	sed "s/__LINUX_IMAGE__/linux-image-rpi/" | \
	sed "s/__EXTRA_PKGS__/- firmware-brcm80211/" | \
	sed "s/__DTB__/\\/usr\\/lib\\/linux-image-*-rpi\\/bcm*rpi-*.dtb/" |\
	sed "s/__SPU_ENABLE__/echo 'deb http:\/\/deb.debian.org\/debian\/ stable-proposed-updates main' >> \/etc\/apt\/sources.list # Raspberries 0\/1 need raspi3-firmware >=  1.20190215-1+deb10u3/" |\
	sed "s/__HOST__/rpi0/" > $@

raspi_2.yaml: raspi_master.yaml
	cat raspi_master.yaml | sed "s/__ARCH__/armhf/" | \
	sed "s/__LINUX_IMAGE__/linux-image-armmp/" | \
	grep -v "__EXTRA_PKGS__" | \
	sed "s/__DTB__/\\/usr\\/lib\\/linux-image-*-armmp\\/bcm*rpi*.dtb/" |\
	sed "s/__SPU_ENABLE__//" |\
	sed "s/__HOST__/rpi2/" > $@

raspi_3.yaml: raspi_master.yaml
	cat raspi_master.yaml | sed "s/__ARCH__/arm64/" | \
	sed "s/__LINUX_IMAGE__/linux-image-arm64/" | \
	sed "s/__EXTRA_PKGS__/- firmware-brcm80211/" | \
	sed "s/__DTB__/\\/usr\\/lib\\/linux-image-*-arm64\\/broadcom\\/bcm*rpi*.dtb/" |\
	sed "s/__SPU_ENABLE__//" |\
	sed "s/__HOST__/rpi3/" > $@

raspi_0w.img : IMAGE=raspi_0w
raspi_0w.img: raspi_0w.yaml _ck_root _build_img

raspi_2.img : IMAGE=raspi_2
raspi_2.img: raspi_2.yaml _ck_root _build_img

raspi_3.img : IMAGE=raspi_3
raspi_3.img: raspi_3.yaml _ck_root _build_img

_build_img:
	[ ! -z "$(IMAGE)" ] # This target is not to be called directly
	touch $(IMAGE).log
	chmod 0644 $(IMAGE).log # Allow for non-root users to follow the build log
	time nice vmdb2 --verbose --rootfs-tarball=$(IMAGE).tar.gz --output=$(IMAGE).img $(IMAGE).yaml --log $(IMAGE).log

_ck_root:
	[ `whoami` = 'root' ] # Only root can summon vmdb2 ☹

_clean_yaml:
	rm -f raspi_0w.yaml raspi_2.yaml raspi_3.yaml
_clean_images:
	rm -f raspi_0w.img raspi_2.img raspi_3.img
_clean_logs:
	rm -f raspi_0w.log raspi_2.log raspi_3.log
_clean_tarballs:
	rm -f raspi_0w.tar.gz raspi_2.tar.gz raspi_3.tar.gz
clean: _clean_images _clean_yaml _clean_tarballs _clean_logs

.PHONY: _ck_root _build_img clean _clean_images _clean_yaml _clean_tarballs _clean_logs
