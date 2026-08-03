{ inputs, lib, ... }:

let
  shared = import ../shared;
  shareable = shared.mkShareable { inherit lib; };
in
{
  flake = {
    nullveilheimConfigurations = {
      inherit (shareable)
        color
        icon
        font
        extraLib
        ;

      nixpkgs = {
        config = {
          allowUnfree = true;
          allowBroken = false;
          contentAddressedByDefault = false;
          tarball-ttl = 86400;
          android_sdk = {
            accept_license = true;
          };
        };

        overlays = lib.attrValues inputs.self.overlays ++ [
          inputs.nixgl.overlay
        ];
      };
    };
  };
}
