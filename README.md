# sphinx-nix

## 1. Overview

Basic application that builds Python Sphinx documentation.
The generated documentation will be served by nginx in a remote environment.

## 2. Prerequisites

Install Nix http://nixos.org/nix/download.html and then `nixops` with

```bash
$ nix-env -i nixops
```


## 3. Nix Build

This step is optional as it will be automatically run by nixops as it evaluates the build expression.

```bash
$ nix-build
```

You can also access a nix shell environment with the package installed by running the following

```bash
$ nix-shell
```

## 4. Nix(ops) deployment

The deployment happens in two phases. First, create the deployment and setting the required arguments

```bash
$ nixops create --deployment sphinx-nix nix/ec2.nix nix/application.nix
```
Make sure to set the appropriate values for the following arguments:

* `accountId`: a symbolic name looked up in ~/.ec2-keys or a ~/.aws/credentials profile name
* `accountId`: the AWS account ID
* `vpcId`: the VPC id used for the target deployment

```bash
$ nixops set-args --deployment sphinx-nix --argstr account "dev" --argstr accountId "123" --argstr vpcId "vpc-foo" 
```

Then by execute the deployment

```bash
$ nixops deploy --deployment sphinx-nix
```

Once the deployment is complete, you can check the details of the deployed machine by running 

```bash
$ nixops info --deployment sphinx-nix
```
