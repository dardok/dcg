# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/dun/conman.git"
	inherit autotools git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86"
	SRC_URI="https://github.com/dun/conman/archive/${P}.tar.gz"
	S=${WORKDIR}/${PN}-${P}
fi

DESCRIPTION="ConMan is a serial console management program."
HOMEPAGE="https://dun.github.io/conman/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="dmalloc tcpd freeipmi debug"

DEPEND="dmalloc? ( dev-libs/dmalloc )
	tcpd? ( sys-apps/tcp-wrappers )
	freeipmi? ( sys-libs/freeipmi )"
#RDEPEND="${CDEPEND}
#	selinux? ( sec-policy/selinux-conman )"

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_with dmalloc)
		$(use_with tcpd tcp-wrappers)
		$(use_with freeipmi)
	)

	econf "${myeconfargs[@]}"
}
