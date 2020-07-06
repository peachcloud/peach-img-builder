all: shasums

shasums: raspi_0w.sha256 raspi_2.sha256 raspi_3.sha256 raspi_0w.xz.sha256 raspi_2.xz.sha256 raspi_3.xz.sha256
xzimages: raspi_0w.img.xz raspi_2.img.xz raspi_3.img.xz
images: raspi_0w.img raspi_2.img raspi_3.img
yaml: raspi_0w.yaml raspi_2.yaml raspi_3.yaml

raspi_0w.yaml: raspi_master.yaml
	cat raspi_master.yaml | sed "s/__ARCH__/armel/" | \
	sed "s/__LINUX_IMAGE__/linux-image-rpi/" | \
	sed "s/__EXTRA_PKGS__/- firmware-brcm80211/" | \
	sed "s/__DTB__/\\/usr\\/lib\\/linux-image-*-rpi\\/bcm*rpi-*.dtb/" |\
	grep -v "__OTHER_APT_ENABLE__" |\
	sed "s/__HOST__/rpi0/" > $@

raspi_2.yaml: raspi_master.yaml
	cat raspi_master.yaml | sed "s/__ARCH__/armhf/" | \
	sed "s/__LINUX_IMAGE__/linux-image-armmp/" | \
	grep -v "__EXTRA_PKGS__" | \
	sed "s/__DTB__/\\/usr\\/lib\\/linux-image-*-armmp\\/bcm*rpi*.dtb/" |\
	sed "s/__OTHER_APT_ENABLE__//" |\
	sed "s/__HOST__/rpi2/" > $@

raspi_3.yaml: raspi_master.yaml
	cat raspi_master.yaml | sed "s/__ARCH__/arm64/" | \
	sed "s/__LINUX_IMAGE__/linux-image-arm64/" | \
	sed "s/__EXTRA_PKGS__/- firmware-brcm80211/" | \
	sed "s/__DTB__/\\/usr\\/lib\\/linux-image-*-arm64\\/broadcom\\/bcm*rpi*.dtb/" |\
	sed "s/__OTHER_APT_ENABLE__//" |\
	sed "s/__HOST__/rpi3/" > $@

%.sha256: %.img.xz
	echo $@
	sha256sum $(@:sha256=img) > $@

%.xz.sha256: %.img.xz
	echo $@
	sha256sum $(@:xz.sha256=img.xz) > $@

%.img.xz: %.img
	xz -f -k -z -9 $(@:.xz=)

%.img: %.yaml
	touch $(@:.img=.log)
	time nice vmdb2 --verbose --rootfs-tarball=$(subst .img,.tar.gz,$@) --output=$@ $(subst .img,.yaml,$@) --log $(subst .img,.log,$@)
	chmod 0644 $@ $(@,.img=.log)

_ck_root:
	[ `whoami` = 'root' ] # Only root can summon vmdb2 ☹

_clean_yaml:
	rm -f raspi_0w.yaml raspi_2.yaml raspi_3.yaml
_clean_images:
	rm -f raspi_0w.img raspi_2.img raspi_3.img
_clean_xzimages:
	rm -f raspi_0w.img.xz raspi_2.img.xz raspi_3.img.xz
_clean_shasums:
	rm -f raspi_0w.sha256 raspi_2.sha256 raspi_3.sha256
_clean_logs:
	rm -f raspi_0w.log raspi_2.log raspi_3.log
_clean_tarballs:
	rm -f raspi_0w.tar.gz raspi_2.tar.gz raspi_3.tar.gz
clean: _clean_xzimages _clean_images _clean_shasums _clean_yaml _clean_tarballs _clean_logs

.PHONY: _ck_root _build_img clean _clean_images _clean_yaml _clean_tarballs _clean_logs
