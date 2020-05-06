EAPI=6

DESCRIPTION="Intel(R) Multi-Buffer Crypto for IPSec"
HOMEPAGE="https://github.com/intel/intel-ipsec-mb"
SRC_URI="https://github.com/intel/intel-ipsec-mb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug safe-data safe-param static-libs"

DEPEND=">=dev-lang/nasm-2.13.03"
RDEPEND=""

src_configure() {
	return
}

src_compile() {
	local myconf

	myconf=""
	if use debug ; then
		myconf="${myconf} DEBUG=y"
	fi
	if use safe-data ; then
		myconf="${myconf} SAFE_DATA=y"
	fi
	if use safe-param ; then
		myconf="${myconf} SAFE_PARAM=y"
	fi
	if use static-libs ; then
		myconf="${myconf} SHARED=n"
	fi

	emake ${myconf}
}

src_install() {
	local myconf

	myconf=""
	if use static-libs ; then
		myconf="${myconf} SHARED=n"
	fi

	emake install NOLDCONFIG=y \
		PREFIX="${ED}/usr" \
		LIB_INSTALL_DIR="${ED}/usr/lib64" \
		MAN_DIR="${ED}/usr/share/man/man7" \
		${myconf}
}
