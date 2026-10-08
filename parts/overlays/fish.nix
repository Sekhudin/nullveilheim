{ inputs, ... }:

{
  flake.overlays.fish =
    _: prev:

    {
      fishPlugins = prev.fishPlugins // {
        nix-env = {
          name = "nix-env";
          src = inputs.nix-env;
        };
      };
    };
}
