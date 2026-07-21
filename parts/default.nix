{ inputs, ... }:

{
  imports = [
    ./devshells
    ./flake
    ./overlays
    ./packages
    ./proces-compose
    ./ez-config.nix
    ./nullveilheim.nix
  ];

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
