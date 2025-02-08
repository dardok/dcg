# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{9..12} )

inherit distutils-r1

DESCRIPTION="Kubernetes Client for Python"
HOMEPAGE="https://kubernetes.io/"
SRC_URI="https://github.com/kubernetes-client/python/archive/refs/tags/v${PV}.tar.gz"
S=${WORKDIR}/python-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-python/cachetools
	dev-python/certifi
	dev-python/durationpy
	dev-python/google-auth
	dev-python/oauthlib
	dev-python/pyasn1-modules
	dev-python/python-dateutil
	dev-python/requests-oauthlib
	dev-python/websocket-client
"

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all
}
