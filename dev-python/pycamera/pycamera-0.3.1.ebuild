# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

DESCRIPTION="An easier solution to computer vision."
HOMEPAGE="https://github.com/IsmaeelAkram/pycamera"
SRC_URI="https://github.com/IsmaeelAkram/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
IUSE=""

RDEPEND=""

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all
}
