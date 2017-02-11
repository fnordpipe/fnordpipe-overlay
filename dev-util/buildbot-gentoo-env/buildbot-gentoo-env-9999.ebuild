# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="environment to build gentoo"
HOMEPAGE="https://www.fnordpipe.org"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

EGIT_REPO_URI="http://git.fnordpipe.org/generic/scripts.git"

inherit git-r3

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
  into /usr
  newbin ${S}/common/publishOnHttp.sh publishOnHttp
  newbin ${S}/common/publishOnRsync.sh publishOnRsync
}
