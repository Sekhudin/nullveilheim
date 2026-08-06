{ inputs, ... }:

let
  inherit (inputs.nixvim.lib.nixvim.modules) buildNixvimWith testNixvimWith;
in
{
  perSystem =
    {
      system,
      color,
      icon,
      font,
      extraLib,
      ...
    }:

    let
      extraSpecialArgs = {
        inherit
          inputs
          color
          icon
          font
          extraLib
          ;
      };

      modules = [
        ./nvim.nix
      ];
    in
    {
      packages = {
        nvim = buildNixvimWith {
          inherit system modules extraSpecialArgs;
        };
      };

      checks = {
        nvim = testNixvimWith {
          inherit system extraSpecialArgs;
          modules = modules ++ [
            {
              plugins = {
                image.enable = false;
              };
            }
          ];
        };
      };
    };
}
