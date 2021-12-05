# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

#MY_PN="vsgGIS"
#MY_P=${MY_PN}-${PV}

DESCRIPTION="Open source high performance 3D graphics toolkit"
HOMEPAGE="https://github.com/vsg-dev/vsgXchange"
#SRC_URI="https://github.com/vsg-dev/${MY_PN}/archive/refs/tags/${MY_P}.tar.gz"
#S="${WORKDIR}/${MY_PN}-${MY_P}"
SRC_URI=""
EGIT_REPO_URI="https://github.com/vsg-dev/vsgGIS.git"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"

BDEPEND="
"
RDEPEND="
	dev-games/vulkanscenegraph
	sci-libs/gdal
"
DEPEND="${RDEPEND}
"

PATCHES=(
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_RELWITHDEBINFO_POSTFIX=""
	)

	cmake_src_configure
}
