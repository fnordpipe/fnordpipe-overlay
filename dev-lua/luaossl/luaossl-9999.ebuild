# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs git-r3

DESCRIPTION="Most comprehensive OpenSSL module in the Lua universe."
HOMEPAGE="https://www.fnordpipe.org"
SRC_URI=""

EGIT_REPO_URI="http://git.fnordpipe.org/ssl/luaossl.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:0 )
	dev-libs/openssl:0[-bindist]
	!dev-lua/lua-openssl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	local version_var=
	local engine=

	use luajit && engine=luajit || engine=lua
	use luajit && version_var=abiver || version_var=V

	LUA_VERSION="$($(tc-getPKG_CONFIG) --variable=${version_var} ${engine})"
}

src_compile() {
	emake CC="$(tc-getCC)" prefix="${EPREFIX}/usr" openssl${LUA_VERSION}
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install${LUA_VERSION}
}
