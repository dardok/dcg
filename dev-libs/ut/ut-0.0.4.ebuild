# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A stripped down fork of boost-ext ut2"
HOMEPAGE="https://github.com/openalgz/ut.git"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openalgz/${PN^}.git"
else
	SRC_URI="https://github.com/openalgz/${PN^}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
"
