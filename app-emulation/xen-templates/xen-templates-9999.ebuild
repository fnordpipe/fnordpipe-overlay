# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="installation templates for xen"
HOMEPAGE="https://www.fnordpipe.org"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

EGIT_REPO_URI="http://git.fnordpipe.org/gentoo/scripts.git"

inherit git-r3

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
  dodir /usr/share/xen/templates
  insinto /usr/share/xen/templates
  newins ${S}/xen/fnordpipe-overlay.sh xen-fnordpipe-overlay
  fperms 0744 /usr/share/xen/templates/xen-fnordpipe-overlay
}
