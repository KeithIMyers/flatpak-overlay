EAPI="5"

inherit eutils

SRC_URI="https://www.x.org/releases/individual/xserver/xorg-server-1.19.3.tar.bz2"

SLOT="0"
KEYWORDS="*"

RESTRICT="mirror"
S="${WORKDIR}/xorg-server-1.19.3"

DEPEND="
    dev-libs/wayland-protocols
    media-libs/libepoxy
    x11-libs/libXfont2
    x11-libs/libxkbfile
    x11-proto/bigreqsproto
    x11-proto/compositeproto
    x11-proto/damageproto
    x11-proto/fontsproto
    x11-proto/presentproto
    x11-proto/randrproto
    x11-proto/recordproto
    x11-proto/renderproto
    x11-proto/resourceproto
    x11-proto/scrnsaverproto
    x11-proto/videoproto
    x11-proto/xcmiscproto
    x11-proto/xf86driproto
    x11-proto/xineramaproto
"

src_prepare() {
    epatch "${FILESDIR}/monotonic-clock-ignore.patch"
}

src_configure() {
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
