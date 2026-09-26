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
      packages = {
        nvim = buildNixvimWith {
          inherit
            system
            extraSpecialArgs
            ;

          modules = [
            ./nixvim
          ];
        };
      };

      checks = {
        nvim = testNixvimWith {
          inherit
            system
            extraSpecialArgs
            ;

          modules = [
            ./nixvim
            {
              plugins.image.enable = false;
            }
          ];
        };
      };
    };
}
