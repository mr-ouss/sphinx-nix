# This file defines a function that takes the below optional argument:
# - 'pkgs', if pkgs is not set, it defaults to importing the nixpkgs found in NIX_PATH
# - 'sphinx_doc', defaults to the location of my codebase
# - 'version', defaults to the version of my application
{ pkgs ? import <nixpkgs> {} 
, sphinx_doc ? ./.
, version ? "1.0"
, system ? builtins.currentSystem
}:
with import <nixpkgs> { inherit system; };
# Defines our application package
pythonPackages.buildPythonPackage {
  # the name of our application
  name = "sphinx-nix-${version}";
  # the codebase of our application
  src = sphinx_doc;
  # this will setup setuptools to use sphinx to compile the documentation
  setupPyBuildFlags = [ "build_sphinx" ];
  # our application depends on sphinx and the sphinx theme 'rtd'
  buildInputs = with pkgs.pythonPackages;
    [ pythonPackages.sphinx
      pythonPackages.sphinx_rtd_theme ];
  # copy the generated documentation to the output directory
  postInstall = ''
    cp -r generated_documentation/html $out/documentation
  '';
}
