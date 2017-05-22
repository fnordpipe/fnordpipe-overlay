# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="fnordpipe ca certificates"
HOMEPAGE="https://www.fnordpipe.com"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

EGIT_REPO_URI="http://git.fnordpipe.org/ssl/ca-certs.git"

DEPEND=""
RDEPEND="
  ${DEPEND}
  app-misc/ca-certificates
  "

src_install() {
  dodir /usr/local/share/ca-certificates
  insinto /usr/local/share/ca-certificates
  newins ${S}/pem/fnordpipe-infrastructure.pem fnordpipe-infrastructure.crt
  newins ${S}/pem/fnordpipe-infrastructure-root-ca.crt.pem fnordpipe-infrastructure-root-ca.crt
  newins ${S}/pem/fnordpipe-infrastructure-machine-ca.crt.pem fnordpipe-infrastructure-machine-ca.crt
}

pkg_postinst() {
  update-ca-certificates
}
