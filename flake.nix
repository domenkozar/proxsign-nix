{
  description = "proXSign signing component for Slovenian national infrastructure";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.proxsign = import ./default.nix {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    };

    packages.x86_64-linux.default = self.packages.x86_64-linux.proxsign;
  };
}
