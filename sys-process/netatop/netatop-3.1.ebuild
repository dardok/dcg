# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod systemd

DESCRIPTION="Per-thread and per-process counters for sys-process/atop"
HOMEPAGE="https://www.atoptool.nl/netatop.php"
SRC_URI="https://www.atoptool.nl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/zlib"

pkg_pretend() {
	linux-mod_pkg_setup
}

pkg_setup() {
	linux-mod_pkg_setup
}

src_configure() {
	# setup linux-mod ugliness
	MODULE_NAMES="netatop(extra:${S}/module:)"
	BUILD_PARAMS='KERNELDIR="${KERNEL_DIR}"'
	BUILD_TARGETS="netatop.ko"
}

src_compile() {
	./mkversion
	linux-mod_src_compile
	make -C ${S}/daemon
}

src_install() {
	linux-mod_src_install
	dosbin daemon/netatopd
	systemd_dounit netatop.service
	doman man/netatop.4
	doman man/netatopd.8
}
