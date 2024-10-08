# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The Open Fabrics Interfaces (OFI) framework"
HOMEPAGE="http://libfabric.org/ https://github.com/ofiwg/libfabric"
SRC_URI="https://github.com/ofiwg/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD GPL-2"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="cuda efa usnic rocr verbs prefix valgrind"

DEPEND="
	rocr? ( dev-libs/rocr-runtime:= )
	usnic? ( dev-libs/libnl:= )
	verbs? ( sys-cluster/rdma-core )
	valgrind? ( dev-debug/valgrind )
"
RDEPEND="
	${DEPEND}
	cuda? ( dev-util/nvidia-cuda-toolkit )
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=(
	AUTHORS
	#CONTRIBUTORS
	NEWS.md
	README
	#README.md
)

PATCHES=( "${FILESDIR}"/null-string.patch "${FILESDIR}"/400g-speed.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		# let's try to avoid automagic deps
		--enable-bgq=no
		# $(usex cuda "--enable-cuda-dlopen" "")
		$(usex cuda "--with-cuda=/opt/cuda" "--without-cuda")
		--enable-efa=$(usex efa yes no)
		--enable-gni=no
		#--enable-gdrcopy-dlopen=no
		--enable-mrail=yes
		--enable-perf=no
		# no psm libraries packaged that I can find (patches accepted)
		--enable-psm=no
		--enable-psm2=no
		--enable-psm3=no
		$(usex rocr "--enable-rocr-dlopen" "")
		--enable-rstream=yes
		--enable-rxd=yes
		--enable-rxm=yes
		--enable-sockets=yes
		--enable-shm=yes
		--enable-tcp=yes
		--enable-udp=yes
		--enable-usnic=$(usex usnic yes no)
		--enable-verbs=$(usex verbs yes no)
		--enable-xpmem=no
		$(usex valgrind "--with-valgrind=/usr/include" "")
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
