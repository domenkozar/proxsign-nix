with (import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/1944dc7e706e172a55125370f603df514518f094.tar.gz";
    sha256 = "01gdnqdz7yjazdvcin6g5fnc3fdnh73k85sy29d6ndmiqhip937q";
  }) {});

stdenv.mkDerivation rec {
  name = "proxysign-${version}";
  version = "2.1.2-58.1";

  src = fetchurl {
    url = "http://www.si-ca.si/podpisna_komponenta/g2/xml2_1_2_58_1/Ubuntu-17.10/proxsign_${version}_amd64.deb";
    sha256 = "0z4z8bk7yhqjsj4yr50nsc7sicfflv842pzcas95dbgg0ssnl8jg";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];
  unpackPhase = "dpkg -x $src ./";

  installPhase = let
      env = with xorg; stdenv.lib.makeLibraryPath [ freetype fontconfig libX11 libXrender xercesc zlib libjpeg_original pango boost162 cairo nss nss_ldap openssl stdenv.cc.cc qt5.qtbase  openldap nspr libxcb xalanc ];
    in ''
    mkdir -p $out/{bin,etc,lib}

    mv usr/bin/proxsign $out/bin/
    mv etc/proxsign.ini $out/etc/

    ln -s ${curl.out}/lib/libcurl.so.4 $out/lib/libcurl-nss.so.4
    patchelf --set-rpath "$out/lib:${env}" \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/proxsign

    wrapProgram $out/bin/proxsign --set QT_PLUGIN_PATH ${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}
  '';
}
