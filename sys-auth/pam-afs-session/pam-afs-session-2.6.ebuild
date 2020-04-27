inherit pam

DESCRIPTION="OpenAFS PAM Module"
HOMEPAGE="http://www.eyrie.org/~eagle/software/pam-afs-session/"
SRC_URI="http://archives.eyrie.org/software/afs/${P}.tar.gz"

LICENSE="HPND openafs-krb5-a"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-crypt/mit-krb5 sys-libs/pam"
RDEPEND="${DEPEND}"

src_compile() {
        econf --with-krb5=/usr --with-afs=/usr --with-aklog=/usr/bin/aklog || die "econf failed"
        emake || die "emake failed"
}

src_install() {
        dopammod .libs/pam_afs_session.so
        doman pam_afs_session.5
        dodoc CHANGES NEWS README TODO
}
