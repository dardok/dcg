# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A pkcs#11 provider for OpenSSL 3.0+"
HOMEPAGE="https://github.com/latchset/pkcs11-provider"
SRC_URI="https://github.com/latchset/${PN}/releases/download/v${PV}/${PN}-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

BDEPEND="app-crypt/p11-kit"
