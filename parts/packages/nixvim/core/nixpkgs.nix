{ inputs, ... }:

let
  inherit (inputs.self.nullveilheim) modules;
in
{
  imports = [
    modules.common.nixpkgs
  ];

  nixpkgs.source = inputs.nixpkgs-unstable;
}
