EAPI=8
inherit cmake

DESCRIPTION="OSSIM is an open source, C++ (mostly), geospatial image processing library used by government, commercial, educational, and private entities throughout the solar system."
HOMEPAGE="https://trac.osgeo.org/ossim/"

if [[ ${PV} = *9999* ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/ossimlabs/ossim"
else
    RELEASE="OrchidIsland"
    SRC_URI="https://github.com/ossimlabs/ossim/archive/refs/tags/${RELEASE}-${PV}.tar.gz -> ${P}.tar.gz"
    S=${WORKDIR}/${PN}-${RELEASE}-${PV}
    KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

IUSE="debug +apps +freetype hdf5 mpi static-libs tests"

RDEPEND="
	sci-libs/geos
	sci-libs/libgeotiff
	dev-libs/jsoncpp
	virtual/jpeg
	sys-libs/zlib
	freetype? ( media-libs/freetype )
	mpi? ( sys-cluster/openmpi )
	hdf5? ( sci-libs/hdf5 )
"

PATCHES=(
    "${FILESDIR}/ossim-cmake-findmpi.patch"
    "${FILESDIR}/ossim-cmake-openjpeg.patch"
    "${FILESDIR}/ossim-ambiguous-overload.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_OMS=OFF
		-DBUILD_OSSIM_APPS=$(usex apps ON OFF)
		-DBUILD_OSSIM_CURL_APPS=OFF
		-DBUILD_OSSIM_FRAMEWORKS=OFF
		-DBUILD_OSSIM_FREETYPE_SUPPORT=$(usex freetype ON OFF)
		-DBUILD_OSSIM_GUI=OFF
		-DBUILD_OSSIM_ID_SUPPORT=ON
		-DBUILD_OSSIM_MPI_SUPPORT=$(usex mpi ON OFF)
		-DBUILD_OSSIM_PLANET=OFF
		-DBUILD_OSSIM_TESTS=$(usex tests ON OFF)
		-DBUILD_OSSIM_VIDEO=OFF
		-DBUILD_OSSIM_WMS=OFF
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
		-DBUILD_OSSIM_HDF5_SUPPORT=$(usex hdf5 ON OFF)
	)

	cmake_src_configure
}

src_install() {
	insinto /usr/share/ossim/cmake/CMakeModules
	doins "${S}"/cmake/CMakeModules/*
	cmake_src_install
}
