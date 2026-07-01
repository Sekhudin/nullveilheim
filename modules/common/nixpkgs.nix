{ ... }:

let
  sharedNixpkgs = import ../../shared/nixpkgs.nix;
in
{
  nixpkgs = {
    inherit (sharedNixpkgs) config;
  };
}
