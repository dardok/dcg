# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hyprland GUI utilities"
HOMEPAGE="https://github.com/hyprwm/hyprland-guiutils"
SRC_URI="https://github.com/hyprwm/${PN}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"

KEYWORDS="amd64"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-libs/hyprlang:=
	gui-libs/hyprutils:=
	gui-libs/hyprtoolkit:=
"
DEPEND="${RDEPEND}"
