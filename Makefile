GENTOOMIRROR?=http://distfiles.gentoo.org

chroot:
	# prepare chroot

	$(eval GENTOOSTAGE3 := $(shell curl -sL ${GENTOOMIRROR}/releases/amd64/autobuilds/latest-stage3-amd64-hardened.txt | tail -n 1 | awk '{ print $$1 }'))

	# prepare chroot rootfs
	mkdir -p ./rootfs ./deploy
	curl -sL ${GENTOOMIRROR}/releases/amd64/autobuilds/${GENTOOSTAGE3} | \
		tee ./deploy/gentoo-stage3-amd64-hardened.tar.bz2 | \
		tar xjpf - -C ./rootfs --exclude='dev/*'
	curl -sL ${GENTOOMIRROR}/snapshots/portage-latest.tar.bz2 | \
		tee ./deploy/gentoo-portage.tar.bz2 | \
		tar xjpf - -C ./rootfs/usr
	mkdir ./rootfs/etc/portage/repos.conf

	# mount pseudofs
	mount -t proc none ./rootfs/proc
	mount -t sysfs none ./rootfs/sys
	mount -t devtmpfs none ./rootfs/dev
	mount -t tmpfs none ./rootfs/dev/shm

	# configure system
	echo "en_US.UTF-8 UTF-8" > ./rootfs/etc/locale.gen

	cp ./rootfs/usr/share/zoneinfo/Etc/UTC ./rootfs/etc/localtime
	cp /etc/resolv.conf ./rootfs/etc/resolv.conf
	curl -sL --insecure http://git.fnordpipe.org/gentoo/scripts.git/plain/chenv.sh > ./rootfs/env.sh

	chmod 0644 ./rootfs/etc/resolv.conf
	chmod 0700 ./rootfs/env.sh
	chown -R portage: ./rootfs/usr/local/fnordpipe-overlay

	# configure portage
	echo "MAKEOPTS=\"-j$$(grep -c ^processor /proc/cpuinfo)\"" > ./rootfs/etc/portage/make.conf

	ln -snf /usr/local/fnordpipe-overlay/metadata/repos.conf ./rootfs/etc/portage/repos.conf/fnordpipe-overlay.conf
	ln -snf ../../usr/local/fnordpipe-overlay/profiles/amd64/headless ./rootfs/etc/portage/make.profile

	rm -rf ./rootfs/etc/portage/package.* || :

	# update environment
	chroot ./rootfs /env.sh locale-gen

clean:
	# clean workdir

	umount ./rootfs/dev/shm ./rootfs/dev ./rootfs/sys ./rootfs/proc
	rm -rf ./deploy ./rootfs

packages:
	# build supported packages

	chroot ./rootfs /env.sh emerge -qb1 app-emulation/lxc
	chroot ./rootfs /env.sh emerge -qb1 dev-python/python2-lxc
	chroot ./rootfs /env.sh emerge -qb1 app-admin/ansible
	chroot ./rootfs /env.sh emerge -qb1 app-admin/vault

	cp -r ./rootfs/usr/portage/packages ./deploy/packages

system:
	# build system

	chroot ./rootfs /env.sh emerge -q1 app-editors/vim
	chroot ./rootfs /env.sh eselect editor set /usr/bin/vim
	chroot ./rootfs /env.sh emerge -q1 virtual/editor

	chroot ./rootfs /env.sh emerge -uNDq system
	chroot ./rootfs /env.sh emerge --depclean

	chroot ./rootfs /env.sh emerge -qb1 sys-devel/gcc
	chroot ./rootfs /env.sh emerge -qb1 sys-kernel/linux-stable
	chroot ./rootfs /env.sh emerge -eqb system --buildpkg-exclude 'virtual/*' --exclude 'sys-devel/gcc'
	chroot ./rootfs /env.sh emerge -qb @preserved-rebuild --buildpkg-exclude 'virtual/*' --exclude 'sys-devel/gcc'

	chroot ./rootfs /env.sh emerge --depclean

	tar cjpf ./deploy/overlay-stage3-amd64-headless.tar.bz2 -C ./rootfs \
		--exclude='env.sh' \
		--exclude='usr/portage' \
		--exclude='usr/local/fnordpipe-overlay' \
		--exclude='proc/*' \
		--exclude='sys/*' \
		--exclude='dev/*' \
		.

	tar cjf ./deploy/overlay-portage.tar.bz2 -C ./rootfs/usr/local \
		--exclude='.git*' \
		--exclude='Makefile' \
		fnordpipe-overlay
