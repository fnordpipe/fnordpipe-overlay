GENTOOMIRROR?=http://distfiles.gentoo.org
CHENVURL?=https://github.com/fnordpipe/scripts/raw/master/chroot/env.sh

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
	curl -sL --insecure ${CHENVURL} > ./rootfs/env.sh

	chmod 0644 ./rootfs/etc/resolv.conf
	chmod 0700 ./rootfs/env.sh
	chown -R portage: ./rootfs/usr/local/fnordpipe-overlay

	# configure portage
	echo "MAKEOPTS=\"-j$$(grep -c ^processor /proc/cpuinfo)\"" > ./rootfs/etc/portage/make.conf
	echo "CHOST=\"x86_64-pc-linux-gnu\"" >> ./rootfs/etc/portage/make.conf
	echo "CFLAGS=\"-O2 -pipe -fomit-frame-pointer\"" >> ./rootfs/etc/portage/make.conf
	echo 'CXXFLAGS="$${CFLAGS}"' >> ./rootfs/etc/portage/make.conf
	echo "CPU_FLAGS_X86=\"mmx sse sse2 sse3 sse4_1 ssse3\"" >> ./rootfs/etc/portage/make.conf
	echo "EMERGE_DEFAULT_OPTS=\"--buildpkg-exclude 'virtual/*'\"" >> ./rootfs/etc/portage/make.conf

	cp ./rootfs/usr/local/fnordpipe-overlay/metadata/repos.conf ./rootfs/etc/portage/repos.conf/fnordpipe.conf
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

	chroot ./rootfs /env.sh emerge -qb1 net-misc/bridge-utils
	chroot ./rootfs /env.sh emerge -qb1 net-misc/curl
	chroot ./rootfs /env.sh emerge -qb1 app-emulation/lxc
	chroot ./rootfs /env.sh emerge -qb1 app-emulation/lxc-templates
	chroot ./rootfs /env.sh emerge -qb1 dev-python/python2-lxc
	chroot ./rootfs /env.sh emerge -qb1 app-emulation/xen-templates
	chroot ./rootfs /env.sh emerge -qb1 app-admin/ansible
	chroot ./rootfs /env.sh emerge -qb1 app-admin/vault
	chroot ./rootfs /env.sh emerge -qb1 dev-util/buildbot
	chroot ./rootfs /env.sh emerge -qb1 dev-util/buildbot-slave
	chroot ./rootfs /env.sh emerge -qb1 net-misc/dhcp
	chroot ./rootfs /env.sh emerge -qb1 net-dns/bind
	chroot ./rootfs /env.sh emerge -qb1 net-nds/openldap
	chroot ./rootfs /env.sh emerge -qb1 net-misc/rabbitmq-server
	chroot ./rootfs /env.sh emerge -qb1 dev-db/redis
	chroot ./rootfs /env.sh emerge -qb1 dev-python/redis-py
	chroot ./rootfs /env.sh emerge -qb1 www-servers/nginx
	chroot ./rootfs /env.sh emerge -qb1 dev-lang/go
	chroot ./rootfs /env.sh emerge -qb1 app-crypt/cfssl
	chroot ./rootfs /env.sh emerge -qb1 net-nds/phpldapadmin
	chroot ./rootfs /env.sh emerge -qb1 dev-db/phpmyadmin
	chroot ./rootfs /env.sh emerge -qb1 dev-db/phppgadmin
	chroot ./rootfs /env.sh emerge -qb1 dev-python/mysql-python
	chroot ./rootfs /env.sh emerge -qb1 dev-db/mariadb
	chroot ./rootfs /env.sh emerge -qb1 dev-db/postgresql
	chroot ./rootfs /env.sh emerge -qb1 dev-python/psycopg
	chroot ./rootfs /env.sh emerge -qb1 net-analyzer/icinga2
	chroot ./rootfs /env.sh emerge -qb1 www-apps/icingaweb2
	chroot ./rootfs /env.sh emerge -qb1 mail-mta/postfix
	chroot ./rootfs /env.sh emerge -qb1 net-mail/dovecot
	chroot ./rootfs /env.sh emerge -qb1 gnustep-apps/sogo
	chroot ./rootfs /env.sh emerge -qb1 dev-lua/luaossl

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
	chroot ./rootfs /env.sh emerge -eqb system --exclude 'sys-devel/gcc sys-kernel/linux-stable'
	chroot ./rootfs /env.sh emerge -qb @preserved-rebuild

	chroot ./rootfs /env.sh emerge --depclean

	tar cjpf ./deploy/overlay-stage3-amd64-headless.tar.bz2 -C ./rootfs \
		--exclude='./env.sh' \
		--exclude='./usr/portage' \
		--exclude='./usr/local/fnordpipe-overlay' \
		--exclude='./proc/*' \
		--exclude='./sys/*' \
		--exclude='./dev/*' \
		.

	tar cjf ./deploy/overlay-portage.tar.bz2 -C ./rootfs/usr/local \
		--exclude='./.git*' \
		--exclude='./Makefile' \
		fnordpipe-overlay
