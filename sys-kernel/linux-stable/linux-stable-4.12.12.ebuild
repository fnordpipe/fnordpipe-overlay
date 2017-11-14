# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="gentoo kernel"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="=sys-kernel/gentoo-sources-${PV}"

inherit toolchain-funcs

src_unpack() {
  cp -rp /usr/src/linux-${PV}-gentoo ${S}
}

src_prepare() {
  cp ${FILESDIR}/Kconfig-${PV} ${S}/.config
  eapply_user
}

src_compile() {
  emake ARCH="$(tc-arch-kernel)" bzImage
  emake ARCH="$(tc-arch-kernel)" modules
}

src_install() {
  dodir /boot
  emake ARCH="$(tc-arch-kernel)" INSTALL_PATH="${D}/boot" install
  emake ARCH="$(tc-arch-kernel)" INSTALL_MOD_PATH="${D}" modules_install

  dosym vmlinuz-${PV}-gentoo /boot/vmlinuz
}
