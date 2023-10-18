# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="Mapnik is an open source toolkit for developing mapping applications"
HOMEPAGE="https://github.com/mapnik/mapnik"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mapnik/mapnik.git"
EGIT_BRANCH="master"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	sci-geosciences/protozero
	sci-geosciences/libosmium
	dev-libs/icu
"
RDEPEND="
"
DEPEND="${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/patch1.patch
	"${FILESDIR}"/patch2.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=17
		-DUSE_BOOST_FILESYSTEM=OFF
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=OFF
		-DBUILD_BENCHMARK=OFF
		-DBUILD_DEMO_VIEWER=OFF
		-DBUILD_DEMO_CPP=OFF
		-DUSE_EXTERNAL_MAPBOX_PROTOZERO=ON
	)

	cmake_src_configure
}
