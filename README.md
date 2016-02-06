# sphinx-nix

## Overview

Basic application that builds Python Sphinx documentation.
The generated documentation will be served by nginx in a remote environment.

## Nix(ops) deployment

Install Nix http://nixos.org/nix/download.html and then nixops with

```bash
$ nix-env -i nixops
```

Then to build the package

```bash
$ nix-build
```

Or to access an environment with the package installed

```bash
$ nix-shell
```

The deployment happens in two phases, firstly by creating the deployment

```bash
$ nixops --deployment sphinx-nix create nix/ec2.nix nix/application.nix
```

And then by executing the deployment

```bash
$ nixops deploy --deployment sphinx-nix
```
