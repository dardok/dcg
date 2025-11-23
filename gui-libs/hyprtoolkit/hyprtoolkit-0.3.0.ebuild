# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A modern C++ Wayland-native GUI toolkit"
HOMEPAGE="https://github.com/hyprwm/hyprtoolkit"
SRC_URI="https://github.com/hyprwm/${PN}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"

KEYWORDS="amd64"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=dev-libs/wayland-1.22.90
	>=gui-libs/hyprutils-0.9.0
	>=dev-libs/hyprlang-0.6.0
	x11-libs/pixman
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/cairo
	dev-libs/iniparser
	>=hyprgraphics-0.3.0
	>=aquamarine-0.9.5
"
DEPEND="${RDEPEND}"
