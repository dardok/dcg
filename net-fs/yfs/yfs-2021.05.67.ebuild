# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULES_OPTIONAL_USE="modules"
inherit autotools linux-mod flag-o-matic pam systemd tmpfiles toolchain-funcs

RESTRICT="bindist mirror fetch strip"

DESCRIPTION="The AuriStor distributed file system"
HOMEPAGE="https://www.auristor.com/filesystem/"
SRC_URI="yfs-2021.05-67.tar.bz2"
MY_PV=2021.05-67

LICENSE="Proprietary"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug fuse +kerberos +modules +namei"

BDEPEND="
	sys-devel/gcc:14
	dev-lang/perl
	sys-devel/flex
	dev-util/byacc
	dev-lang/yasm"
DEPEND="
	virtual/libcrypt:=
	!sys-auth/pam-afs-session
	!net-fs/openafs
	!net-fs/openafs-kernel
	virtual/libintl
	fuse? ( sys-fs/fuse:0= )
	sys-libs/pam
	kerberos? ( virtual/krb5 )
	sys-libs/libselinux"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( )

CONFIG_CHECK="~!AFS_FS KEYS"
ERROR_AFS_FS="OpenAFS conflicts with the in-kernel AFS-support. Make sure not to load both at the same time!"
ERROR_KEYS="OpenAFS needs CONFIG_KEYS option enabled"

QA_TEXTRELS_x86_fbsd="/boot/modules/libafs.ko"
QA_TEXTRELS_amd64_fbsd="/boot/modules/libafs.ko"

pkg_nofetch() {
    einfo "The yfs-2021.05-64.tar.bz2 archive should be placed into your distfiles directory."
}

pkg_setup() {
	use kernel_linux && linux-mod_pkg_setup
}

src_prepare() {
	default

	# fixing 2-nd level makefiles to honor flags
	sed -i -r 's/\<CFLAGS[[:space:]]*=/CFLAGS+=/; s/\<LDFLAGS[[:space:]]*=/LDFLAGS+=/' \
		src/*/Makefile.in || die '*/Makefile.in sed failed'
	# fix xml docs to use local dtd files
	sed -i 's|http://www.oasis-open.org/docbook/xml/4.3|/usr/share/sgml/docbook/xml-dtd-4.3|' \
		doc/xml/*/*000.xml || die

	# packaging is f-ed up, so we can't run eautoreconf
	# run autotools commands based on what is listed in regen.sh
	eaclocal -I src/cf -I src/external/rra-c-util/m4 -I src/external/heimdal/cf -I src/external/autoconf-archive/m4
	eautoconf
	eautoconf -o configure-libafs configure-libafs.ac
	eautoheader
	einfo "Deleting autom4te.cache directory"
	rm -rf autom4te.cache || die
}

src_configure() {
	local -a myconf

	if use debug; then
		use modules && myconf+=( --enable-debug-kernel )
	fi

	if use modules; then
		if use kernel_linux; then
			if kernel_is -ge 3 17 && kernel_is -le 3 17 2; then
				myconf+=( --enable-linux-d_splice_alias-extra-iput )
			fi
			myconf+=( --with-linux-kernel-headers="${KV_DIR}" \
					  --with-linux-kernel-build="${KV_OUT_DIR}" )
		fi
	fi

	local ARCH="$(tc-arch-kernel)"
	local MY_ARCH="$(tc-arch)"

	AFS_SYSKVERS=26 \
	econf \
		--disable-strip-binaries \
		$(use_enable debug) \
		$(use_enable debug debug-locks) \
		$(use_enable fuse fuse-client) \
		$(use_enable modules kernel-module) \
		$(use_enable namei namei-fileserver) \
		$(use_with kerberos krb5) \
		$(use_with kerberos gssapi) \
		"${myconf[@]}"
}

src_compile() {
	ARCH="$(tc-arch-kernel)" AR="$(tc-getAR)" emake V=1
}

src_install() {
	emake DESTDIR="${ED}" install_nolibafs

	if use modules; then
		if use kernel_linux; then
			local srcdir=$(expr "${S}"/src/libafs/MODLOAD-*)
			[[ -f ${srcdir}/yfs.${KV_OBJ} ]] || die "Couldn't find compiled kernel module"

			MODULE_NAMES="yfs(fs/yfs:${srcdir})"

			linux-mod_src_install
		fi
	fi

	insinto /usr/share/yfs
	doins src/csdb/cellservdb.conf

	insinto /etc/yfs
	doins ${FILESDIR}/yfs-client.conf

	# pam_afs_session has been installed in irregular location, fix
	dopammod "${ED}"/usr/$(get_libdir)/security/pam_afs*
	rm -rf "${ED}"/usr/$(get_libdir)/security || die

	# Gentoo related scripts
	#dotmpfiles "${SYSTEMDDIR}"/tmpfiles.d/openafs-client.conf
	systemd_dounit "${FILESDIR}"/yfs-client.service

	# used directories: client
	keepdir /etc/yfs
}

pkg_postinst() {
	if use modules; then
		# Update linker.hints file
		use kernel_linux && linux-mod_pkg_postinst
	fi

	#tmpfiles_process openafs-client.conf

	elog "This installation should work out of the box (at least the"
	elog "client part doing global afs-cell browsing, unless you had"
	elog "a previous and different configuration).  If you want to"
	elog "set up your own cell or modify the standard config,"
	elog "please have a look at the Gentoo OpenAFS documentation"
	elog "(warning: it is not yet up to date wrt the new file locations)"
	elog
	elog "The documentation can be found at:"
	elog "  https://wiki.gentoo.org/wiki/OpenAFS"
}

pkg_postrm() {
	if use modules; then
		# Update linker.hints file
		use kernel_linux && linux-mod_pkg_postrm
	fi
}
