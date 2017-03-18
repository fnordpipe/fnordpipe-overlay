# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="pki-api for scalable infrastructures"
HOMEPAGE="https://www.fnordpipe.org"
SRC_URI=""

EGIT_REPO_URI="http://git.fnordpipe.org/ssl/laprassl.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
  dodir /etc/laprassl
  dodir /var/lib/laprassl
  dodir /usr/share/webapps/${PN}/${PV}
  insinto /usr/share/webapps/${PN}/${PV}

  doins -r ${S}/src/*
}
