# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Graphics / resource related utilities used across the hypr* ecosystem"
HOMEPAGE="https://github.com/hyprwm/hyprgraphics"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="BSD"
SLOT="0"

# Disable tests since as per upstream, tests require a theme to be installed
# See also https://github.com/hyprwm/hyprcursor/commit/94361fd8a75178b92c4bb24dcd8c7fac8423acf3
RESTRICT="test"

RDEPEND="
	sys-apps/file
	media-libs/libjpeg-turbo
	media-libs/libwebp
	media-libs/libjxl
	x11-libs/pixman
	x11-libs/cairo
"
