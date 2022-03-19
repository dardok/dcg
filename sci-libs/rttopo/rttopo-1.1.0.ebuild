# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools

MY_PN="lib${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="RT Topology Library"
HOMEPAGE="https://git.osgeo.org/gogs/rttopo/librttopo"
#SRC_URI="https://git.osgeo.org/gitea/rttopo/${MY_PN}/archive/${MY_PN}-${MY_P}.tar.gz"
#S="${WORKDIR}/${MY_PN}"

SRC_URI=""
EGIT_REPO_URI="https://git.osgeo.org/gitea/rttopo/librttopo.git"
EGIT_COMMIT="98a8bdd0b2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv x86"
RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}
src_configure() {
	econf
}
