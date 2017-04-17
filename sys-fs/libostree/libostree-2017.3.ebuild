# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils systemd

SRC_URI="https://github.com/ostreedev/ostree/releases/download/v${PV}/${P}.tar.xz"
DESCRIPTION="OSTree is a tool for managing bootable, immutable, versioned filesystem trees."
HOMEPAGE="https://github.com/ostreedev/ostree"

LICENSE="LGPL-2"
SLOT="0"

IUSE="curl introspection doc man +soup systemd"

KEYWORDS="amd64"

# NOTE: soup/curl is optional, but not if you want to use flatpaks in a meaningful way,
# so we force it.
REQUIRED_USE="|| ( soup curl )"

# TODO(nicholasbishop): check on fuse-2.9.2, glib-2.40:2
# NOTE2: curl needs soup for tests right now (17 Feb 2017)
RDEPEND="
	dev-libs/glib
	>=app-arch/xz-utils-5.0.5
	sys-libs/zlib
	>=sys-fs/fuse-2.9.2
	>=app-crypt/gpgme-1.1.8
	>=app-arch/libarchive-2.8
	net-misc/curl
	systemd? ( sys-apps/systemd )
"

# TODO(nicholasbishop): libsoup-2.42 is min version because
# SOUP_CHECK_VERSION is used which was not added until 2.42. Orig
# ebuild had libsoup-2.40 here.

DEPEND="${RDEPEND}
	sys-devel/bison
	virtual/pkgconfig
	sys-fs/e2fsprogs
	curl? ( >=net-libs/libsoup-2.42 )
	introspection? ( >=dev-libs/gobject-introspection-1.34 )
	doc? ( >=dev-util/gtk-doc-1.15 )
	man? ( dev-libs/libxslt )
"

RESTRICT=mirror

src_prepare() {

	# FIXME: should work through the build system really
	epatch "${FILESDIR}/0001-ot-gpg-utils-use-gentoo-include-path.patch"

	#eapply_user

	eautoreconf

}

src_configure() {
	# TODO(nicholasbishop): hack
	export GPGME_CONFIG=$(which ${CHOST}-gpgme-config)

	local myconf=()

	# FIXME: it is not possible to hard disable systemd in the configure script.
	# systemd only seems needed for booting ostree
	use systemd \
		&& myconf+=( --with-systemdsystemunitdir="$(systemd_get_systemunitdir)" )

	if ! use soup && use curl; then
		myconf+=( $(use_with curl) )
	fi

	if use soup; then
		myconf+=( $(use_with soup) )
	fi

	# FIXME: selinux should be use-flagged
	econf \
		--without-dracut \
		--without-mkinitcpio \
		--with-libarchive \
		--without-selinux \
		--without-libmount \
		$(use_enable introspection) \
		$(use_enable doc gtk-doc) \
		$(use_enable man) \
		"${myconf[@]}"

}

src_install() {

	default

	# FIXME: figure out what is failing
	# see https://github.com/fosero/flatpak-overlay/issues/1
	rm -f ${D}/etc/grub.d/15_ostree

}
