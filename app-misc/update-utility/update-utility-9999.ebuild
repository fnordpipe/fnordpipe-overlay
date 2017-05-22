# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="os update utility"
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
  exeopts -m744
  exeinto /usr/sbin
  doexe ${S}/common/updateGentoo.sh
  doexe ${S}/common/reboot.sh
}
