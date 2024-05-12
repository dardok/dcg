# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{9..12} )

inherit distutils-r1

DESCRIPTION="Provides service endpoint configuration per service on profile"
HOMEPAGE="https://pypi.org/project/awscli-plugin-endpoint/"
SRC_URI="https://github.com/wbingli/${PN}/archive/refs/tags/${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
IUSE=""

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all
}
