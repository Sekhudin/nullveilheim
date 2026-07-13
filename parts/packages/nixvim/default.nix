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

    {
      packages = {
        nvim = buildNixvimWith {
          inherit system;

          extraSpecialArgs = {
            inherit
              color
              icon
              font
              extraLib
              ;
          };

          modules = [
            ./nvim.nix
          ];
        };
      };

      checks = {
        nvim = testNixvimWith {
          inherit system;

          extraSpecialArgs = {
            inherit color font extraLib;
          };

          modules = [
            ./nvim.nix
          ];
        };
      };
    };
}
