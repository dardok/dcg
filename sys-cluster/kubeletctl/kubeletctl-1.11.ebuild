# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
GIT_COMMIT=4b4b989e59ea6b0a9e64c87cabf407a45c39b137

DESCRIPTION="A client for kubelet"
HOMEPAGE="https://github.com/cyberark/kubeletctl"
SRC_URI="https://github.com/cyberark/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT+=" test"

src_compile() {
	go build -ldflags "-s -w" || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
