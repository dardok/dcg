EAPI=8
inherit cmake

DESCRIPTION="OSSIM is an open source, C++ (mostly), geospatial image processing library used by government, commercial, educational, and private entities throughout the solar system."
HOMEPAGE="https://trac.osgeo.org/ossim/"

if [[ ${PV} = *9999* ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/ossimlabs/ossim-plugins"
else
    RELEASE="OrchidIsland"
    SRC_URI="https://github.com/ossimlabs/ossim-plugins/archive/${RELEASE}-${PV}.tar.gz -> ${P}.tar.gz"
    S=${WORKDIR}/${PN}-${RELEASE}-${PV}
    KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

IUSE="debug atp aws fftw gdal geopdf kml opencv +png potrace jpeg2k registration sqlite web"

RDEPEND="
    sci-libs/ossim
    atp? ( >=media-libs/opencv-3.2[contrib,contrib_xfeatures2d] )
    aws? ( dev-cpp/aws-sdk[s3] )
    fftw? ( sci-libs/fftw:3.0 )
    gdal? ( >=sci-libs/gdal-2.2 )
    geopdf? ( app-text/podofo )
    kml? ( sys-libs/zlib[minizip] )
    opencv? ( >=media-libs/opencv-3.2 )
    png? (
        media-libs/libpng:0
        media-libs/tiff:0
    )
    jpeg2k? ( media-libs/openjpeg:2 )
    potrace? ( media-gfx/potrace )
    sqlite? (
        dev-db/sqlite:3
        media-libs/libpng:0
        virtual/jpeg
    )
    registration? ( media-libs/opencv )
    web? (
        net-misc/curl
    )
"

PATCHES=(
    "${FILESDIR}/ossim-cmake-modules.patch"
    "${FILESDIR}/ossim-vector.patch"
)

src_configure() {
    BUILD_KAKADU_PLUGIN=OFF
    if [ ! -z "$KAKADU_ROOT_SRC" ] && [ ! -z "$KAKADU_AUX_LIB" ] && [ ! -z "$KAKADU_LIB" ] ; then
        ln -sfn $KAKADU_ROOT_SRC $S/kakadu/KAKADU_ROOT_SRC
        ln -sfn $KAKADU_AUX_LIB $S/kakadu/KAKADU_AUX_LIB
        ln -sfn $KAKADU_LIB $S/kakadu/KAKADU_LIB
        BUILD_KAKADU_PLUGIN=ON
    fi

    local mycmakeargs=(
        -DBUILD_ATP_PLUGIN=$(usex atp ON OFF)
        -DBUILD_AWS_PLUGIN=$(usex aws ON OFF)
        -DBUILD_CNES_PLUGIN=OFF
        -DBUILD_DEM_PLUGIN=ON
        -DBUILD_FFTW3_PLUGIN=$(usex fftw ON OFF)
        -DBUILD_GDAL_PLUGIN=$(usex gdal ON OFF)
        -DBUILD_GEOPDF_PLUGIN=$(usex geopdf ON OFF)
        -DBUILD_JPEG12_PLUGIN=OFF
        -DBUILD_KAKADU_PLUGIN=$BUILD_KAKADU_PLUGIN
        -DBUILD_KML_PLUGIN=$(usex kml ON OFF)
        -DBUILD_MRSID_PLUGIN=OFF
        -DBUILD_MSP_PLUGIN=OFF
        -DBUILD_OPENCV_PLUGIN=$(usex opencv ON OFF)
        -DBUILD_OPENJPEG_PLUGIN=$(usex jpeg2k ON OFF)
        -DBUILD_PDAL_PLUGIN=OFF
        -DBUILD_PNG_PLUGIN=$(usex png ON OFF)
        -DBUILD_POTRACE_PLUGIN=$(usex potrace ON OFF)
        -DBUILD_REG_PLUGIN=$(usex registration ON OFF)
        -DBUILD_SQLITE_PLUGIN=$(usex sqlite ON OFF)
        -DBUILD_WEB_PLUGIN=$(usex web ON OFF)
    )

    cmake_src_configure
}
