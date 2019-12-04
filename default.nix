with (import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/093faad9684796975520d9d88503e76ab539b8ef.tar.gz";
    sha256 = "0v3an5f5anvqqfpihp9sgrhnzv68qvjihq16mjhfycglsz758z6p";
  }) {});

stdenv.mkDerivation rec {
  name = "proxysign-${version}";
  version = "2.1.4-1+9.1";

  src = fetchurl {
    url = "https://www.si-trust.gov.si/assets/proxsign/druga-generacija/linux/v2.1.4.9.1/Ubuntu-18.04/proxsign_${version}_amd64.deb";
    sha256 = "002bxf1qzl5qjmqrlikpljkx8pg3a4fmn8bj38mr5y76m8rchkgy";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];
  unpackPhase = "dpkg -x $src ./";

  installPhase = let
    env = with xorg; stdenv.lib.makeLibraryPath [
      freetype
      fontconfig
      libX11
      libXrender
      xercesc
      zlib
      pango
      boost165
      cairo
      nss
      nss_ldap
      openssl
      stdenv.cc.cc
      qt5.qtbase
      openldap
      nspr
      libxcb
      xalanc
      (libjpeg_original.overrideDerivation (p: {
        name = "libjpeg-8d";
        src = fetchurl {
          url = http://www.ijg.org/files/jpegsrc.v8d.tar.gz;
          sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
        };
      }))
    ];
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
