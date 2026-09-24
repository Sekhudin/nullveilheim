{ inputs, ... }:

let
  inherit (inputs.self.nullveilheim.nixpkgs) config overlays;
in
{
  nixpkgs = {
    inherit config overlays;
  };
}
