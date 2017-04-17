# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_{5,6,7} )

inherit gnome2 python-any-r1

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="http://live.gnome.org/LibSoup"

LICENSE="LGPL-2+"
SLOT="2.4"
KEYWORDS="*"
IUSE="debug +introspection samba ssl test"

RDEPEND=">=dev-libs/glib-2.33.1:2
	>=dev-libs/libxml2-2:2
	>=net-libs/glib-networking-2.30.0[ssl?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	samba? ( net-fs/samba )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	virtual/pkgconfig"
#	test? (	www-servers/apache[ssl,apache2_modules_auth_digest,apache2_modules_alias,apache2_modules_auth_basic,
#		apache2_modules_authn_file,apache2_modules_authz_host,apache2_modules_authz_user,apache2_modules_dir,
#		apache2_modules_mime,apache2_modules_proxy,apache2_modules_proxy_http,apache2_modules_proxy_connect]
#		dev-lang/php[apache2,xmlrpc]
#		net-misc/curl
#		net-libs/glib-networking[ssl])"

src_prepare() {
	epatch "${FILESDIR}/bishop-werror.patch"

	if ! use test; then
		# don't waste time building tests (bug #226271)
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	gnome2_src_prepare
}

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index

	# Disable apache tests until they are usable on Gentoo, bug #326957
	gnome2_src_configure \
		--disable-static \
		--disable-tls-check \
		--without-gnome \
		--without-apache-httpd \
		$(use_enable introspection) \
		$(use_with samba ntlm-auth "${EPREFIX}"/usr/bin/ntlm_auth)
}
