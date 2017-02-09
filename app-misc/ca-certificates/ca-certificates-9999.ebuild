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
RDEPEND="${DEPEND}"

src_install() {
  dodir /usr/share/ca-certificates/fnordpipe
  insinto /usr/share/ca-certificates/fnordpipe
  newins ${S}/pem/fnordpipe-infrastructure.pem fnordpipe-infrastructure.pem
  newins ${S}/pem/digicert-highassurance.pem digicert-highassurance.pem

  cat ${S}/pem/*.pem > ${S}/cert.pem

  dodir /etc/ssl
  insinto /etc/ssl
  newins ${S}/cert.pem cert.pem

  # link cert for compatibility with applications written in golang
  dosym /etc/ssl/cert.pem /etc/ssl/certs/ca-certificates.crt
}
