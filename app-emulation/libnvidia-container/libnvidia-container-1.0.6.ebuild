EAPI=6

DESCRIPTION="Library and a simple CLI utility to automatically configure GNU/Linux containers leveraging NVIDIA hardware."
HOMEPAGE="https://github.com/NVIDIA/libnvidia-container"

inherit git-r3
EGIT_REPO_URI="https://github.com/NVIDIA/libnvidia-container.git"
if [[ ${PV} != *9999* ]]; then
    [[ ${PV} =~ ([0-9]+.[0-9]+.[0-9]+) ]] && \
        EGIT_COMMIT="v"${BASH_REMATCH[1]}"" || \
        die "Couldn't parse version"
fi

LICENSE="NVIDIA-r2"
SLOT="0"

IUSE="+system-libelf +seccomp tools"

RDEPEND="
    system-libelf? ( dev-libs/elfutils )
    net-libs/libtirpc
    seccomp? ( sys-libs/libseccomp )
"

ELF_VERSION=0.7.1
ELF_NAME=elftoolchain-${ELF_VERSION}
MODPROBE_VERSION=396.51
MODPROBE_NAME=nvidia-modprobe-${MODPROBE_VERSION}
SRC_URI="!system-libelf? ( https://sourceforge.net/projects/elftoolchain/files/Sources/${ELF_NAME}/${ELF_NAME}.tar.bz2 )
    https://github.com/NVIDIA/nvidia-modprobe/archive/${MODPROBE_VERSION}.tar.gz -> ${MODPROBE_NAME}.tar.gz"

DOCS="NOTICE LICENSE COPYING COPYING.LESSER"

PATCHES=(
	"${FILESDIR}/${PV}-makefile-system-tirpc.patch"
)

src_unpack() {
    git-r3_src_unpack

    for x in ${A}; do
        case ${x} in
            ${ELF_NAME}*)
                dest=${S}/deps/src/${ELF_NAME}
                mkdir -p ${dest} || die
                unpack ${x}
                mv ${ELF_NAME}/{mk,common,libelf} ${dest}
                touch ${dest}/.download_stamp
                ;;
            ${MODPROBE_NAME}*)
                dest=${S}/deps/src/${MODPROBE_NAME}
                mkdir -p ${dest} || die
                unpack ${x}
                mv ${MODPROBE_NAME}/modprobe-utils ${dest}
                touch ${dest}/.download_stamp
                ;;
        esac
    done
}

src_compile() {
    MAKEOPTS="$MAKEOPTS -j1"

    emake prefix="${EPREFIX}/usr" \
        CUDA_DIR=/opt/cuda \
        WITH_LIBELF=$(usex system-libelf yes no) \
        WITH_TIRPC=yes \
        WITH_SECCOMP=$(usex seccomp yes no) \
        shared $(usex tools tools "")
}

src_install() {
    doheader src/nvc.h

    dolib.so libnvidia-container.so.${PV%%_*} # SONAME?

    local v
    for v in libnvidia-container.so{,.{${PV%%.*},${PV%.*}}} ; do
        dosym libnvidia-container.so.${PV%%_*} /usr/$(get_libdir)/${v}
    done

    dodir /usr/$(get_libdir)/pkgconfig
    LIB_LDLIBS_SHARED="-ldl -lcap"
    use system-libelf && LIB_LDLIBS_SHARED+=" -lelf"
    use seccomp && LIB_LDLIBS_SHARED+=" -lseccomp"
    prefix="${EPREFIX}/usr" \
    exec_prefix="\${prefix}" \
    libdir="${EPREFIX}/usr/$(get_libdir)" \
    includedir="\${prefix}/include" \
        "${S}"/mk/${PN}.pc.in "${PV}" "${LIB_LDLIBS_SHARED}" > "${D}"/usr/$(get_libdir)/pkgconfig/${PN}.pc
    
    use tools && dobin nvidia-container-cli

    einstalldocs
}
