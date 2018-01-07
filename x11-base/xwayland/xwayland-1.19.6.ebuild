EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/xserver"
EGIT_COMMIT="xorg-server-1.19.6"

inherit autotools git-r3 multilib

SLOT="0"
KEYWORDS="*"
LICENSE="MIT"

# TODO(nicholasbishop): for now do this:
#    sudo emerge wayland
# Need to add that as a proper dep in the SDK somewhere

RDEPEND="
    dev-libs/nettle
    dev-libs/wayland
    x11-libs/libXau
    x11-libs/libXdmcp
    x11-libs/libXfont2
    x11-apps/xkbcomp
"

DEPEND="
    ${RDEPEND}
    dev-libs/wayland-protocols
    media-libs/libepoxy
"

src_prepare() {
    epatch "${FILESDIR}/0001-configure.ac-Fix-check-for-CLOCK_MONOTONIC.patch"

	eautoreconf
}

src_configure() {
    # https://wayland.freedesktop.org/xserver.html
	econf \
        --disable-devel-docs \
        --disable-docs \
        --disable-glx \
        --disable-xnest \
        --disable-xorg \
        --disable-xquartz \
        --disable-xvfb \
        --disable-xwin \
        --enable-xwayland
}
