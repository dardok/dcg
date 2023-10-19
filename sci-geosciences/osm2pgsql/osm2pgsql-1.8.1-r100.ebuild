# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake lua-single

DESCRIPTION="Converts OSM planet.osm data to a PostgreSQL/PostGIS database"
HOMEPAGE="https://osm2pgsql.org/"
SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+lua system-protozero system-libosmium"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

COMMON_DEPEND="
	app-arch/bzip2
	dev-cpp/nlohmann_json
	dev-db/postgresql:=
	dev-libs/boost
	dev-libs/expat
	sci-libs/proj:=
	sys-libs/zlib
	dev-python/psycopg:2
	dev-python/pyyaml
	system-protozero? ( sci-geosciences/protozero )
	system-libosmium? ( sci-geosciences/libosmium )
	lua? ( ${LUA_DEPS} )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost:=
"
RDEPEND="${COMMON_DEPEND}
	sci-libs/gdal
"

# Tries to connect to local postgres server and other shenanigans
RESTRICT="test"

PATCHES=(
)

src_configure() {
	# Setting WITH_LUAJIT without "if use lua" guard is safe, upstream
	# CMakeLists.txt only evaluates it if WITH_LUA is true.
	local mycmakeargs=(
		-DWITH_LUA=$(usex lua)
		-DWITH_LUAJIT=$(usex lua_single_target_luajit)
		-DBUILD_TESTS=OFF
		-DEXTERNAL_LIBOSMIUM=$(usex system-protozero)
		-DEXTERNAL_PROTOZERO=$(usex system-libosmium)
	)
	# To prevent the "unused variable" QA warning
	if use lua && ! use lua_single_target_luajit; then
		mycmakeargs+=( -DLUA_VERSION="$(lua_get_version)" )
	fi
	cmake_src_configure
}
