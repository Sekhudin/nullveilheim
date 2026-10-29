{ inputs, ... }:

let
  inherit (inputs.self.nullveilheim) modules;
in
{
  imports = [
    modules.common.nixpkgs
  ];
}
