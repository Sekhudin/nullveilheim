{ inputs, ... }:

let
  inherit (inputs.nixvim.lib.nixvim.modules)
    buildNixvimWith
    testNixvimWith
    ;
in
{
  perSystem =
    {
      system,
      color,
      icon,
      extraLib,
      ...
    }:

    let
      extraSpecialArgs = {
        inherit
          inputs
          color
          icon
          extraLib
          ;
      };
    in
    {
      packages.nixvim = buildNixvimWith {
        inherit
          system
          extraSpecialArgs
          ;

        modules = [
          ./modules.nix
        ];
      };

      checks.nixvim = testNixvimWith {
        inherit
          system
          extraSpecialArgs
          ;

        modules = [
          ./modules.nix
          {
            plugins.image.enable = false;
          }
        ];
      };
    };
}
