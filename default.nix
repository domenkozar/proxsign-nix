with (import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/9e86f5f7a19db6da2445f07bafa6694b556f9c6d.tar.gz";
    sha256 = "sha256:0i2j7bf6jq3s13n12xahramami0n6zn1mksqgi01k7flpgyymcck";
  }) {});

let 
  oldnixpkgs = (import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/3e1be2206b4c1eb3299fb633b8ce9f5ac1c32898.tar.gz";
    sha256 = "sha256:11d01fdb4d1avi7564h7w332h3jjjadsqwzfzpyh5z56s6rfksxc";
  }) {});

in stdenv.mkDerivation rec {
  pname = "proxsign";
  version = "2.2.7";

  src = fetchurl {
    url = "https://proxsign.setcce.si/proxsign/repo/xUbuntu_20.04/amd64/proxsign_2.2.7-1+10.3_amd64.deb";
    #sha256 = "sha256:1a0p7njy8krf41fpvxvl3qf2ydgsyhcigysyrb9wjd483nryxzaj";
    sha256 = "sha256:1gc4ikxgy8fa243j6hc4nr7wx8imn256ixks7vb25vnnrii21dij";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];
  unpackPhase = "dpkg -x $src ./";

  installPhase = let
    env = with xorg; lib.makeLibraryPath [
      freetype
      libX11
      libXrender
      xercesc
      zlib
      pango
      boost165
      cairo
      libtiff
      libpng
      podofo
      nss
      nss_ldap
      openssl
      stdenv.cc.cc
      qt5.qtbase
      openldap
      libunistring
      oldnixpkgs.libidn
      nspr
      libxcb
      xalanc
      fontconfig
      (libjpeg_original.overrideDerivation (p: {
        name = "libjpeg-8d";
        src = fetchurl {
          url = http://www.ijg.org/files/jpegsrc.v8d.tar.gz;
          sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
        };
      }))
    ];
  in ''
    mkdir -p $out/{bin,etc,share,lib}

    mv usr/bin/proxsign $out/bin/
    mv etc/proxsign.ini $out/etc/
    mv usr/share/{applications,icons} $out/share
    mv usr/lib/*/libp* $out/lib/

    ln -s ${curl.out}/lib/libcurl.so.4 $out/lib/libcurl-nss.so.4

    patchelf --set-rpath "$out/lib:${env}" \
      $out/lib/libpxs-podofo.so.0.9.7
    patchelf --set-rpath "$out/lib:${env}" \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/proxsign

    wrapProgram $out/bin/proxsign --set QT_PLUGIN_PATH ${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}
  '';
}
