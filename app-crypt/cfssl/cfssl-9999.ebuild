# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-vcs-vendor golang-build user

DESCRIPTION="CFSSL: Cloudflare's PKI and TLS toolkit"
HOMEPAGE="https://cfssl.org/"
SRC_URI=""

EGO_PN="github.com/cloudflare/cfssl/..."

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
  >=dev-lang/go-1.6
  dev-vcs/git
"
RDEPEND="
  ${DEPEND}
  dev-go/ratelimit
"

SVCNAME="cfssl"

pkg_setup() {
  enewgroup ${SVCNAME}
  enewuser ${SVCNAME} -1 -1 /dev/null ${SVCNAME}
}

src_prepare() {
  epatch "${FILESDIR}/0001-fix-missing-headers.patch"
  eapply_user
}

src_install() {
  golang-build_src_install

  exeinto /usr/bin
  doexe "${S}"/bin/*

  dodir /etc/${PN}
  dodir /etc/${PN}/csr
  dodir /var/lib/${PN}

  fowners ${SVCNAME}:${SVCNAME} -R /etc/${PN}
  fowners ${SVCNAME}:${SVCNAME} /var/lib/${PN}

  rm -rf ${D}/usr/lib/go-gentoo
}
