EAPI=7

PYTHON_COMPAT=( pypy3 python3_{9..12} )

inherit distutils-r1

DESCRIPTION="Module for converting between datetime.timedelta and Go's Duration strings."
HOMEPAGE="https://github.com/icholy/durationpy"
SRC_URI="https://github.com/icholy/durationpy/archive/refs/tags/${PV}.tar.gz"
S=${WORKDIR}/python-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all
}
