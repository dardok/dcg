# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit apache-module depend.apache git-r3 cmake

DESCRIPTION="An Apache 2 module to deliver map tiles and renders map tiles using mapnik"
HOMEPAGE="https://github.com/openstreetmap/mod_tile"
SRC_URI=""
EGIT_REPO_URI="https://github.com/openstreetmap/mod_tile.git"
EGIT_BRANCH="master"

LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="memcached rados"

APACHE2_MOD_FILE="${BUILD_DIR}/src/mod_tile.so"
APACHE2_MOD_CONF="50_${PN}"
APACHE2_MOD_DEFINE="TILES"

BDEPEND="
	www-servers/apache
"
RDEPEND="
	dev-libs/boost
	dev-libs/icu
	dev-libs/libnl
	x11-libs/cairo
	dev-libs/glib
	sci-geosciences/mapnik
	>=dev-libs/iniparser-4
	memcached? ( net-misc/memcached )
	rados? ( sys-cluster/librados )
"
DEPEND="${RDEPEND}
"

PATCHES=(
)

need_apache2

# Work around Bug #616612
pkg_setup() {
	_init_apache2
	_init_apache2_late
}

src_configure() {
	cmake_src_configure
}

src_install() {
	apache-module_src_install

	dosbin "${BUILD_DIR}"/src/renderd
	dobin "${BUILD_DIR}"/src/render_list

	insinto /etc
	doins "${BUILD_DIR}"/renderd.conf
}
