# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RESTRICT="bindist mirror fetch strip"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
WANT_LIBTOOL="latest"

if [[ $PV = *9999* ]]; then
	scm="git-r3"
	SRC_URI=""
	EGIT_REPO_URI="git://git.whamcloud.com/fs/lustre-release.git"
	KEYWORDS=""
	EGIT_BRANCH="master"
else
	scm=""
	SRC_URI="lustre-release-2.15.6_rc1.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-release-${PV^^}"
fi

SUPPORTED_KV_MAJOR=6
SUPPORTED_KV_MINOR=6

inherit ${scm} autotools linux-info linux-mod toolchain-funcs udev flag-o-matic

DESCRIPTION="Lustre is a parallel distributed file system"
HOMEPAGE="http://wiki.whamcloud.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client +utils +modules server readline tests o2ib gss +lru-resize +checksum"

RDEPEND="
	app-alternatives/awk
	readline? ( sys-libs/readline:0 )
	server? (
		>=sys-fs/zfs-kmod-0.8
		>=sys-fs/zfs-0.8
	)
"
BEPEND="${RDEPEND}
	dev-python/docutils
	virtual/linux-sources"

REQUIRED_USE="
	client? ( modules )
	server? ( modules )"

PATCHES=( )

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
	if [ ${#PATCHES[0]} -ne 0 ]; then
		eapply ${PATCHES[@]}
	fi

	eapply_user
	# replace upstream autogen.sh by our src_prepare()
	local DIRS="libcfs lnet lustre"
	local ACLOCAL_FLAGS
	for dir in $DIRS ; do
		ACLOCAL_FLAGS="$ACLOCAL_FLAGS -I $dir/autoconf"
	done
	_elibtoolize -q
	eaclocal -I config $ACLOCAL_FLAGS
	eautoheader
	eautomake
	eautoconf
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
