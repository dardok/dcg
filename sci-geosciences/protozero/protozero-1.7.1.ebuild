EAPI=8

inherit cmake

DESCRIPTION="Minimalistic protocol buffer decoder and encoder in C++"
HOMEPAGE="https://github.com/mapbox/protozero"
SRC_URI="https://github.com/mapbox/${PN}/archive/refs/tags/v${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PV}"

LICENSE="Apache-2.0"
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
