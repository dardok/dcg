# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Asynchronous SSH for Python"
HOMEPAGE="https://asyncssh.readthedocs.io/en/latest/"
SRC_URI="https://github.com/ronf/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
IUSE=""

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all
}
