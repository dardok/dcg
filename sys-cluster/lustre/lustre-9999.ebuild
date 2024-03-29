# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.16"
WANT_LIBTOOL="latest"

scm="git-r3"
SRC_URI=""
EGIT_REPO_URI="git://git.whamcloud.com/fs/lustre-release.git"
KEYWORDS=""
EGIT_BRANCH="master"
EGIT_OVERRIDE_COMMIT_FS_LUSTRE_RELEASE="a17cefe53f9f7536eb1916b9e73a5d43053386dc"

SUPPORTED_KV_MAJOR=5
SUPPORTED_KV_MINOR=15

inherit ${scm} autotools linux-info linux-mod toolchain-funcs udev flag-o-matic

DESCRIPTION="Lustre is a parallel distributed file system"
HOMEPAGE="http://wiki.whamcloud.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client +utils +modules +dlc server readline tests o2ib gss +lru-resize +checksum cuda gds"

RDEPEND="
	app-alternatives/awk
	dlc? ( dev-libs/libyaml )
	readline? ( sys-libs/readline:0 )
	server? (
		>=sys-fs/zfs-kmod-0.8
		>=sys-fs/zfs-0.8
	)
"
BDEPEND="sys-devel/gcc:12"
DEPEND="${RDEPEND}
	dev-python/docutils
	virtual/linux-sources"

REQUIRED_USE="
	client? ( modules )
	server? ( modules )"

pkg_pretend() {
	KVSUPP=${SUPPORTED_KV_MAJOR}.${SUPPORTED_KV_MINOR}.x
	if kernel_is gt ${SUPPORTED_KV_MAJOR} ${SUPPORTED_KV_MINOR}; then
		eerror "Unsupported kernel version! Latest supported one is ${KVSUPP}"
		die
	fi
}

pkg_setup() {
	filter-mfpmath sse
	filter-mfpmath i386
	filter-flags -msse* -mavx* -mmmx -m3dnow

	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	eapply -p1 "${FILESDIR}/gcc12.patch"
	eapply_user
	if [[ ${PV} == "9999" ]]; then
		# replace upstream autogen.sh by our src_prepare()
		local DIRS="libcfs lnet lustre snmp"
		local ACLOCAL_FLAGS
		for dir in $DIRS ; do
			ACLOCAL_FLAGS="$ACLOCAL_FLAGS -I $dir/autoconf"
		done
		_elibtoolize -q
		eaclocal -I config $ACLOCAL_FLAGS
		eautoheader
		eautomake
		eautoconf
	fi
}

src_configure() {
	local myconf
	if use server; then
		SPL_PATH=$(basename $(echo "${EROOT}/usr/src/spl-"*)) \
			myconf="${myconf} --with-spl=${EROOT}/usr/src/${SPL_PATH} \
			--with-spl-obj=${EROOT}/usr/src/${SPL_PATH}/${KV_FULL}"
		ZFS_PATH=$(basename $(echo "${EROOT}/usr/src/zfs-"*)) \
			myconf="${myconf} --with-zfs=${EROOT}/usr/src/${ZFS_PATH} \
			--with-zfs-obj=${EROOT}/usr/src/${ZFS_PATH}/${KV_FULL}"
	fi
	if use cuda; then
		myconf="${myconf} --with-cuda=/usr/src/nvidia"
	fi
	if use gds; then
		myconf="${myconf} --with-gds=/root/gds-nvidia-fs/src"
	fi
	if use o2ib; then
		if [ -d /usr/src/ofa_kernel/default ]; then
			myconf="${myconf} --with-o2ib=/usr/src/ofa_kernel/default"
		else
			myconf="${myconf} --with-o2ib"
		fi
	fi
	econf \
		${myconf} \
		--without-ldiskfs \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-obj="${KBUILD_OUTPUT}" \
		$(use_enable dlc) \
		$(use_enable client) \
		$(use_enable utils) \
		$(use_enable modules) \
		$(use_enable server) \
		$(use_enable readline) \
		$(use_enable tests) \
		$(use_enable gss) \
		$(use_enable lru-resize) \
		$(use_enable checksum)
}

src_compile() {
	default
}

src_install() {
	default
}
