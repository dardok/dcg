# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Ssome qt/qml utilities that might be used by various hypr* apps."
HOMEPAGE="https://github.com/hyprwm/hyprland-qtutils"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	kde-frameworks/qqc2-desktop-style:6
	dev-qt/qtwayland:6
"
