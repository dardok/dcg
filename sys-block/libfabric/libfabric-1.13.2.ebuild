EAPI=6

inherit autotools

DESCRIPTION="OFI"

SRC_URI="https://github.com/ofiwg/libfabric/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""

DEPEND="sys-fabric/librdmacm
		sys-fabric/libibverbs
		sys-fabric/libibumad
		"
RDEPEND="${DEPEND}"
