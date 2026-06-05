# Proxsign (for Linux using Nix)

This repository contains reproducible installation for proxsign signing component
required for some Slovenian national infrastructure.

> **Note:** Upstream now distributes proXSign as an AppImage. This package wraps it using
> `appimageTools` for seamless use on NixOS and other Linux distributions with Nix.

## Installation

First you'll need to install Nix via terminal (works on any Linux distribution):

    $ curl -L https://nixos.org/nix/install | sh
    $ source ~/.nix-profile/etc/profile.d/nix.sh

Then install proxsign:

    $ nix-env -i -f https://github.com/domenkozar/proxsign-nix/tarball/master

Or run it directly without installing (requires flakes):

    $ nix run github:domenkozar/proxsign-nix

### Installing on NixOS (classic)

If you are using NixOS you can also add the package to your `configuration.nix`.

To pin to a specific version, pick a commit hash from the [repository history](https://github.com/domenkozar/proxsign-nix/commits/master)
and fetch its sha256:

    $ nix-prefetch-url --unpack https://github.com/domenkozar/proxsign-nix/archive/<git-commit-hash>.tar.gz

Then add it to your `configuration.nix` and rebuild:

```nix
environment.systemPackages = [
  # ProxSign
  (import (builtins.fetchTarball {
    url = "https://github.com/domenkozar/proxsign-nix/archive/<git-commit-hash>.tar.gz";
    sha256 = "<output from nix-prefetch-url above>";
  }))
];
```

### Installing on NixOS (flakes)

Add to your `flake.nix` inputs:

```nix
inputs.proxsign.url = "github:domenkozar/proxsign-nix";
```

Then add the package to your system:

```nix
environment.systemPackages = [
  inputs.proxsign.packages.x86_64-linux.proxsign
];
```

## Usage

### 1. Run the application in terminal

    $ proxsign

You should see GUI application display a list of your certificates (sigenca, etc).

### 2. Whitelist self-signed certificate in your browser

Chromium:

- Open https://localhost:14972/
- You should see "Your connection is not private"
- Click "Advanced"
- Click "Proceed to localhost (unsafe)" (yes, that's "right")
- You will get an `404` error, which is fine

Firefox:
- Open https://localhost:14972/
- Add an exception for certificate
- You will get an `404` error, which is fine

### 3. Verify that everything works

- Open http://www.si-ca.si/podpisna_komponenta/g2/Testiranje_podpisovanja_IEFF_adv_g2.php
- Click "Podpisi"
- Click "Vredu"
- Click "Preveri podpis"


## Uninstall Nix package manager (optional)

    $ sudo rm -rf /nix
    $ sudo rm -rf ~/.nix-*

# References

- http://www.si-ca.si/podpisna_komponenta/g2/navodilo-linux_2_1_2_58_1.php
