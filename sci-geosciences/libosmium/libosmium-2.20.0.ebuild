EAPI=8

inherit cmake

DESCRIPTION="A fast and flexible C++ library for working with OpenStreetMap data"
HOMEPAGE="https://osmcode.org/libosmium"
SRC_URI="https://github.com/osmcode/${PN}/archive/refs/tags/v${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
"
RDEPEND="
"
DEPEND="${RDEPEND}
"

PATCHES=(
)
