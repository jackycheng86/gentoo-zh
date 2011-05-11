# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils autotools

DESCRIPTION="hand write recognition/input using ibus IM engine"
HOMEPAGE="http://code.google.com/p/ibus-handwrite/"
EGIT_REPO_URI="git://github.com/microcai/${PN}.git"

SRC_URI="
	http://ibus-handwrite.googlecode.com/files/${P}.tar.bz2
	zinnia? ( mirror://sourceforge/zinnia/zinnia-tomoe/0.6.0-20080911/zinnia-tomoe-0.6.0-20080911.tar.bz2 )"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+zinnia +nls"

RDEPEND="
	>=app-i18n/ibus-1.2
	nls? ( virtual/libintl )
	zinnia? ( app-i18n/zinnia )"


DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )"

src_unpack(){
	if use zinnia ; then
		unpack zinnia-tomoe-0.6.0-20080911.tar.bz2
	fi
	unpack ${P}.tar.bz2
}

src_configure() {

	if use zinnia ; then

	( cd ../zinnia-tomoe-0.6.0-20080911 && econf )   || die

	ECONF="$ECONF $(use_enable zinnia)
	--with-zinnia-tomoe=/usr/share/${PN}/data
	"
	fi

	econf $(use_enable nls) $ECONF || die

}

src_compile(){

	if use zinnia ; then
		( cd ../zinnia-tomoe-0.6.0-20080911 && emake )   || die
	fi

	emake || die
}

src_install(){
	emake install DESTDIR=${D} || die

	if use zinnia ; then

	cd ../zinnia-tomoe-0.6.0-20080911

	install handwriting-ja.model ${D}/usr/share/ibus-handwrite/data/ || die
	install handwriting-zh_CN.model ${D}/usr/share/ibus-handwrite/data/ || die

	fi

}




