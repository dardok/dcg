# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Linux Driver support for the CoolKey and CAC products"
HOMEPAGE="https://directory.fedora.redhat.com/wiki/CoolKey"
SRC_URI="https://directory.fedora.redhat.com/download/coolkey/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

RDEPEND=">=sys-apps/pcsc-lite-1.6.4
	dev-libs/nss[utils]
	sys-libs/zlib"

DEPEND="${RDEPEND}
	>=app-crypt/ccid-1.4.0
	virtual/pkgconfig"

src_prepare() {
	patch -Np0 -i "${FILESDIR}/coolkey-cache-dir-move.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-gcc43.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-latest.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-simple-bugs.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-thread-fix.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-cac.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-cac-1.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-pcsc-lite-fix.patch"
	patch -Np1 -i "${FILESDIR}/coolkey-fix-token-removal-failure.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-update.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-more-keys.patch"
	patch -Np0 -i "${FILESDIR}/coolkey-1.1.0-max-cpu-bug.patch"
	default
}

src_configure() {
	econf \
		--enable-pk11install \
		--disable-static \
		$(use_enable debug)
}

src_compile() {
	emake CFLAGS+="-fno-strict-aliasing" -j1
}
