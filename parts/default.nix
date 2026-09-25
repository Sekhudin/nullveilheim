{ inputs, ... }:

{
  imports = [
    ./devshells
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
        inherit (inputs.self.nullveilheim)
          color
          icon
          font
          extraLib
          ;

        extraModuleArgs = {
          inherit (inputs.self.nullveilheim)
            color
            icon
            font
            extraLib
            ;
        };
      };
    };
}
