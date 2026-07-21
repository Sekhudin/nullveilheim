{ inputs, lib, ... }:

{
  nixpkgs = {
    inherit (inputs.self.nullveilheimConfigurations.nixpkgs) config;
    overlays = (lib.attrValues inputs.self.overlays);
  };
}
