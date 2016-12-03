# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="dhcp hoot to update ansible cache"
HOMEPAGE="https://www.fnordpipe.org"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

EGIT_REPO_URI="http://git.fnordpipe.org/gentoo/scripts.git"

inherit git-r3

DEPEND=""
RDEPEND="
  dev-python/configparser
  dev-python/redis-py
"

src_install() {
  dodir /etc/dhcp
  insinto /etc/dhcp
  doins ${FILES}/ansible.ini

  dodir /usr/libexec/dhcp/hooks
  insinto /usr/libexec/dhcp/hooks
  newins ${S}/dhcp/ansible.py ansible.py
  fowners dhcp:dhcp /usr/libexec/dhcp/hooks/ansible.py
  fperms 0744 /usr/libexec/dhcp/hooks/ansible.py
}
