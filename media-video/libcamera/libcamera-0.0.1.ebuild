# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson

DESCRIPTION="libcamera"
HOMEPAGE="https://www.libcamera.org/"
SRC_URI=""
EGIT_REPO_URI="https://git.libcamera.org/libcamera/libcamera.git"
EGIT_BRANCH="master"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="android android_platform cam docs gstreamer ipas lc-compliance pipelines qcam test tracing v4l2 pycamera"

DEPEND="pycamera? ( dev-python/pycamera )"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/system-pybind.patch )

src_configure() {
	local emesonargs=(
		--localstatedir "${EPREFIX}/var"

		#$(meson_feature android)
		#$(meson_feature android_platform)
		$(meson_feature cam)
		$(meson_feature docs documentation)
		$(meson_feature gstreamer)
		#$(meson_feature ipas)
		$(meson_feature lc-compliance)
		#$(meson_feature pipelines)
		$(meson_feature qcam)
		$(meson_use test)
		$(meson_feature tracing)
		$(meson_use v4l2)
		$(meson_feature pycamera)
	)

	local emesonargs+=( -Dipas=ipu3,rkisp1,rpi/vc4,vimc )
	local emesonargs+=( -Dpipelines=auto )

	meson_src_configure
}

src_install() {
	meson_src_install
}
