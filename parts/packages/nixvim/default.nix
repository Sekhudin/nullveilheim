{ inputs, ... }:

let
  inherit (inputs.nixvim.lib.nixvim.modules) buildNixvimWith testNixvimWith;
in
{
  perSystem =
    {
      system,
      ...
    }:

    {
      packages = {
        nvim = buildNixvimWith {
          inherit system;

          modules = [ ./config ];
        };
      };

      checks = {
        nvim = testNixvimWith {
          inherit system;

          modules = [ ./config ];
        };
      };
    };
}
