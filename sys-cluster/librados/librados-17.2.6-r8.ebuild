# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
LUA_COMPAT=( lua5-{3..4} )

inherit cmake flag-o-matic \
		readme.gentoo-r1 toolchain-funcs systemd tmpfiles

SRC_URI="
	https://download.ceph.com/tarballs/ceph-${PV}.tar.gz
"
S="${WORKDIR}/ceph-${PV}"
KEYWORDS="amd64 ~arm64"

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="https://ceph.com/"

LICENSE="Apache-2.0 LGPL-2.1 CC-BY-SA-3.0 GPL-2 GPL-2+ LGPL-2+ LGPL-2.1 LGPL-3 GPL-3 BSD Boost-1.0 MIT public-domain"
SLOT="0"

CPU_FLAGS_X86=(avx2 avx512f pclmul sse{,2,3,4_1,4_2} ssse3)

IUSE="
	rdma
"

IUSE+="$(printf "cpu_flags_x86_%s\n" ${CPU_FLAGS_X86[@]})"

DEPEND="
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/snappy:=
	>=app-arch/snappy-1.1.9-r1
	app-arch/zstd:=
	dev-libs/openssl:=
	sys-apps/coreutils
	sys-apps/util-linux:=
	sys-libs/zlib:=
	sys-process/numactl:=
	virtual/libcrypt:=
	rdma? ( sys-cluster/rdma-core:= )
"
# <cython-3: bug #907739
BDEPEND="
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/yasm )
	app-arch/cpio
	>=dev-util/cmake-3.5.0
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/util-linux
	sys-apps/which
	sys-devel/bc
	sys-devel/patch
	virtual/pkgconfig
"
RDEPEND="
	${DEPEND}
	app-alternatives/awk
"
REQUIRED_USE="
"

RESTRICT="
"

# false positives unless all USE flags are on
CMAKE_WARN_UNUSED_CLI=no

PATCHES=(
	"${FILESDIR}/ceph-12.2.0-use-provided-cpu-flag-values.patch"
	"${FILESDIR}/ceph-14.2.0-cflags.patch"
	"${FILESDIR}/ceph-12.2.4-boost-build-none-options.patch"
	"${FILESDIR}/ceph-16.2.2-cflags.patch"
	"${FILESDIR}/ceph-17.2.1-no-virtualenvs.patch"
	"${FILESDIR}/ceph-13.2.2-dont-install-sysvinit-script.patch"
	"${FILESDIR}/ceph-14.2.0-dpdk-cflags.patch"
	"${FILESDIR}/ceph-16.2.0-rocksdb-cmake.patch"
	"${FILESDIR}/ceph-16.2.0-spdk-tinfo.patch"
	"${FILESDIR}/ceph-16.2.0-jaeger-system-boost.patch"
	"${FILESDIR}/ceph-16.2.0-liburing.patch"
	"${FILESDIR}/ceph-17.2.0-cyclic-deps.patch"
	"${FILESDIR}/ceph-17.2.0-pybind-boost-1.74.patch"
	"${FILESDIR}/ceph-17.2.0-findre2.patch"
	"${FILESDIR}/ceph-17.2.0-install-dbstore.patch"
	"${FILESDIR}/ceph-17.2.0-deprecated-boost.patch"
	"${FILESDIR}/ceph-17.2.0-system-opentelemetry.patch"
	"${FILESDIR}/ceph-17.2.0-fuse3.patch"
	"${FILESDIR}/ceph-17.2.0-osd_class_dir.patch"
	"${FILESDIR}/ceph-17.2.0-gcc12-header.patch"
	"${FILESDIR}/ceph-17.2.3-flags.patch"
	"${FILESDIR}/ceph-17.2.4-cyclic-deps.patch"
	# https://bugs.gentoo.org/866165
	"${FILESDIR}/ceph-17.2.5-suppress-cmake-warning.patch"
	"${FILESDIR}/ceph-17.2.5-gcc13-deux.patch"
	"${FILESDIR}/ceph-17.2.5-boost-1.81.patch"
	# https://bugs.gentoo.org/901403
	"${FILESDIR}/ceph-17.2.6-link-boost-context.patch"
	# https://bugs.gentoo.org/905626
	"${FILESDIR}/ceph-17.2.6-arrow-flatbuffers-c++14.patch"
	# https://bugs.gentoo.org/868891
	"${FILESDIR}/ceph-17.2.6-cmake.patch"
	# https://bugs.gentoo.org/907739
	"${FILESDIR}/ceph-18.2.0-cython3.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -e "s:objdump -p:$(tc-getOBJDUMP) -p:" -i CMakeLists.txt || die

	# remove tests that need root access
	rm src/test/cli/ceph-authtool/cap*.t || die
}

ceph_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DWITH_BABELTRACE:BOOL=OFF
		-DWITH_BLUESTORE:BOOL=OFF
		-DWITH_BLUESTORE_PMEM:BOOL=OFF
		-DWITH_CEPHFS:BOOL=OFF
		-DWITH_CEPHFS_SHELL:BOOL=OFF
		-DWITH_DPDK:BOOL=OFF
		-DWITH_SPDK:BOOL=OFF
		-DWITH_FUSE:BOOL=OFF
		-DWITH_LTTNG:BOOL=OFF
		-DWITH_GSSAPI:BOOL=OFF
		-DWITH_GRAFANA:BOOL=OFF
		-DWITH_MGR:BOOL=OFF
		-DWITH_MGR_DASHBOARD_FRONTEND:BOOL=OFF
		-DWITH_OPENLDAP:BOOL=OFF
		-DWITH_PYTHON3:STRING=3
		-DWITH_RADOSGW:BOOL=OFF
		-DWITH_RADOSGW_AMQP_ENDPOINT:BOOL=OFF
		-DWITH_RADOSGW_KAFKA_ENDPOINT:BOOL=OFF
		-DWITH_RADOSGW_LUA_PACKAGES:BOOL=OFF
		-DWITH_RBD_RWL:BOOL=OFF
		-DWITH_RBD_SSD_CACHE:BOOL=OFF
		-DWITH_SYSTEMD:BOOL=OFF
		-DWITH_TESTS:BOOL=OFF
		-DWITH_LIBURING:BOOL=OFF
		-DWITH_SYSTEM_LIBURING:BOOL=OFF
		-DWITH_LIBCEPHSQLITE:BOOL=OFF
		-DWITH_XFS:BOOL=OFF
		-DWITH_ZBD:BOOL=OFF
		-DWITH_ZFS:BOOL=OFF
		-DENABLE_SHARED:BOOL=ON
		-DALLOCATOR:STRING='libc'
		-DWITH_SYSTEM_PMDK:BOOL=OFF
		-DWITH_SYSTEM_BOOST:BOOL=OFF
		-DWITH_SYSTEM_ROCKSDB:BOOL=OFF
		-DWITH_SYSTEM_ZSTD:BOOL=ON
		-DWITH_RDMA:BOOL=$(usex rdma)
		-DWITH_JAEGER:BOOL=OFF
		-DWITH_RADOSGW_SELECT_PARQUET:BOOL=OFF
		-DCMAKE_INSTALL_DOCDIR:PATH="${EPREFIX}/usr/share/doc/${PN}-${PVR}"
		-DCMAKE_INSTALL_SYSCONFDIR:PATH="${EPREFIX}/etc"
		# use the bundled libfmt for now since they seem to constantly break their API
		-DCMAKE_DISABLE_FIND_PACKAGE_fmt=ON
		-Wno-dev
		-DWITH_KRBD:BOOL=OFF
		-DWITH_LIBCEPHFS:BOOL=OFF
	)

	# conditionally used cmake args
	if use amd64 || use x86; then
		local flag
		for flag in "${CPU_FLAGS_X86[@]}"; do
			case "${flag}" in
				avx*)
					local var=${flag%f}
					mycmakeargs+=(
						"-DHAVE_NASM_X64_${var^^}:BOOL=$(usex cpu_flags_x86_${flag})"
					)
				;;
				*) mycmakeargs+=(
						"-DHAVE_INTEL_${flag^^}:BOOL=$(usex cpu_flags_x86_${flag})"
					);;
			esac
		done
	fi

	# needed for >=glibc-2.32
	has_version '>=sys-libs/glibc-2.32' && mycmakeargs+=( -DWITH_REENTRANT_STRSIGNAL:BOOL=ON )

	rm -f "${BUILD_DIR:-${S}}/CMakeCache.txt" \
		|| die "failed to remove cmake cache"

	cmake_src_configure

	# bug #630232
	sed -i "s:\"${T//:\\:}/${EPYTHON}/bin/python\":\"${PYTHON}\":" \
		"${BUILD_DIR:-${S}}"/include/acconfig.h \
		|| die "sed failed"
}

src_configure() {
	ceph_src_configure
}

src_compile() {
	cmake_build librados
}

src_install() {
	dolib.so "${BUILD_DIR:-${S}}"/lib/libceph-common.so*
	dolib.so "${BUILD_DIR:-${S}}"/lib/librados.so*

	for x in $(find ${S}/src/include/rados -type l) ; do rm -f ${x} ; cp ${S}/src/include/$(basename ${x}) ${x} ; done ;
	doheader -r ${S}/src/include/rados
}
