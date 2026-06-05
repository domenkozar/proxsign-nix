{ pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/b86751bc4085f48661017fa226dee99fab6c651b.tar.gz";
    sha256 = "sha256:0z1xwfdy3blm5n06lyabyjhadiy79rbm5z4kf309z85kg65mih3b";
  }) {}
}:

pkgs.appimageTools.wrapType2 {
  pname = "proxsign";
  version = "2.2.13.38";
  src = pkgs.fetchurl {
    url = "https://public.setcce.si/proxsign/update/linux/SETCCE_proXSign-2.2.13.38-x86_64.AppImage";
    hash = "sha256-Ixe0XjErci2ID4YUx/zr4pf1XTi3M2n9E/IIh2DPYB8=";
  };
  extraPkgs = pkgs: [ pkgs.gmp pkgs.curl ];
}
