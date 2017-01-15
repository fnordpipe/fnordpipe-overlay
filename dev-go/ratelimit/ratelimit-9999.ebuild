# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-vcs golang-build

DESCRIPTION="Efficient token-bucket-based rate limiter package"
HOMEPAGE="https://github.com/juju/ratelimit"
SRC_URI=""

EGO_PN="github.com/juju/ratelimit/..."

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=dev-lang/go-1.6"
RDEPEND="${DEPEND}"
