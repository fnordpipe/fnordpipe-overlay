# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="gentoo hardened kernel"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="=sys-kernel/hardened-sources-${PV}"

ARCH="x86_64"

src_unpack() {
  cp -rp /usr/src/linux-${PV}-hardened ${S}
}

src_prepare() {
  cp ${FILESDIR}/Kconfig-${PV} ${S}/.config
}

src_compile() {
  emake bzImage
  #emake modules
}

src_install() {
  dodir /boot
  emake INSTALL_PATH="${D}/boot" install
  #emake INSTALL_MOD_PATH="${D}" modules_install
}
