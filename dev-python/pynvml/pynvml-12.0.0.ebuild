# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..12} )

inherit distutils-r1

DESCRIPTION="Python bindings to the NVIDIA Management Library"
HOMEPAGE="https://github.com/gpuopenanalytics/pynvml"
SRC_URI="https://github.com/gpuopenanalytics/${PN}/archive/refs/tags/${PV}.tar.gz"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
IUSE=""

RDEPEND="
	x11-drivers/nvidia-drivers
"

python_install_all() {
	distutils-r1_python_install_all
}
