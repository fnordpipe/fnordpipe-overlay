# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="lxc python2 bindings"
HOMEPAGE="https://github.com/lxc/python2-lxc"
SRC_URI="https://github.com/lxc/python2-lxc/archive/master.zip -> python2-lxc.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

S="${WORKDIR}/${PN}-master"

DEPEND="
  dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND=""
