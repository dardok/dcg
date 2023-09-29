# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Mellanox Update and Query Utility"
HOMEPAGE="https://www.mellanox.com/support/firmware/mlxup-mft"
SRC_URI="https://www.mellanox.com/downloads/firmware/${MY_PN}/${PV}/SFX/linux_x64/${MY_PN} -> ${MY_P}-amd64.elf"
S="${WORKDIR}"

LICENSE="Mellanox-AS-IS"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

QA_PREBUILT="*/${MY_PN}"

src_install() {
	newsbin "${DISTDIR}/${MY_P}-amd64.elf" ${MY_PN}
}
