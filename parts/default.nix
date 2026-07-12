{ inputs, lib, ... }:

let
  shared = import ../shared;
  shareable = shared.mkShareable { inherit lib; };
in
{
  imports = [
    ./devshells
    ./flake
    ./overlays
    ./ez-config.nix
  ];

  flake = {
    nullveilheimConfigurations = {
      inherit (shareable)
        color
        icon
        font
        extraLib
        ;
    };
  };

  perSystem =
    {
      inputs',
      ...
    }:

    {
      formatter = inputs'.nixpkgs.legacyPackages.nixfmt;

      _module.args = {
        inherit (inputs.self.nullveilheimConfigurations)
          color
          icon
          font
          extraLib
          ;

        extraModuleArgs = {
          inherit (inputs.self.nullveilheimConfigurations)
            color
            icon
            font
            extraLib
            ;
        };
      };
    };
}
