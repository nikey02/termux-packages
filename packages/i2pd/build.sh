TERMUX_PKG_HOMEPAGE=https://i2pd.website/
TERMUX_PKG_DESCRIPTION="A full-featured C++ implementation of the I2P router"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_VERSION=2.32.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/PurpleI2P/i2pd/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=64229101411a9dda3237dc27939aa13ec90d4900aae499e59931063c36e8556b
TERMUX_PKG_DEPENDS="boost, miniupnpc, openssl, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_UPNP:BOOL=ON"
TERMUX_PKG_RM_AFTER_INSTALL="src"

TERMUX_PKG_CONFFILES="
etc/i2pd/i2pd.conf
etc/i2pd/tunnels.conf
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/build"
	CXXFLAGS="${CXXFLAGS/-Oz/-O2}"
}

termux_step_post_make_install() {
	cd $TERMUX_PKG_SRCDIR/../

	install -Dm600 -t "$TERMUX_PREFIX"/etc/i2pd \
		./contrib/i2pd.conf \
		./contrib/tunnels.conf

	local _file _dir
	while read -r -d '' _file; do
		_dir="${_file#contrib/certificates}"
		_dir="${_dir%/*}"
		install -Dm600 "$_file" -t "${TERMUX_PREFIX}/share/i2pd/certificates/${_dir}"
	done < <(find contrib/certificates -type f -print0)

	install -Dm600 -t "${TERMUX_PREFIX}"/share/doc/i2pd/tunnels.d \
		./contrib/tunnels.d/README \
		./contrib/tunnels.d/IRC-Ilita.conf \
		./contrib/tunnels.d/IRC-Irc2P.conf

	install -Dm600 -t "${TERMUX_PREFIX}"/share/man/man1 ./debian/i2pd.1
}
