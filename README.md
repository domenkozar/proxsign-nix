# Proxsign (for Linux using Nix)

[![Build Status](https://travis-ci.org/domenkozar/proxsign-nix.svg?branch=master)](https://travis-ci.org/domenkozar/proxsign-nix)

This repository contains reproducible installation for proxsign signing component
required for some Slovenian national infrastructure.

## Installation


First you'll need to install Nix via terminal (work on any Linux distribution):

    $ curl -L https://nixos.org/nix/install | sh
    $ source ~/.nix-profile/etc/profile.d/nix.sh

Then install proxsign:

    $ nix-env -i -f https://github.com/domenkozar/proxsign-nix/tarball/master


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

Firefox:
- Open https://localhost:14972/
- Add an exception for certificate

### 4. Verify everything works

- Open http://www.si-ca.si/podpisna_komponenta/g2/Testiranje_podpisovanja_IEFF_adv_g2.php
- Click "Podpisi"
- Click "Vredu"
- Click "Preveri podpis"


## Uninstall

    $ sudo rm -rf /nix
    $ sudo rm -rf ~/.nix-*

# References

- http://www.si-ca.si/podpisna_komponenta/g2/navodilo-linux_2_1_2_58_1.php
