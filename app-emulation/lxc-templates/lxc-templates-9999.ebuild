# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="installation templates for lxc"
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
  dodir /usr/share/lxc/templates
  insinto /usr/share/lxc/templates
  newins ${S}/lxc/fnordpipe-overlay.sh lxc-fnordpipe-overlay
  fperms 0744 /usr/share/lxc/templates/lxc-fnordpipe-overlay
}
