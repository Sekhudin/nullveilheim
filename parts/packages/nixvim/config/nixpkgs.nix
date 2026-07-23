{ inputs, ... }:

let
  inherit (inputs.self.nullveilheimConfigurations.nixpkgs) config overlays;
in
{
  nixpkgs = {
    inherit config overlays;
  };
}
