{ inputs, ... }:

{
  flake.overlays.packages =
    _: prev:

    let
      system = prev.stdenv.hostPlatform.system;
    in
    {
      inherit (inputs.self.packages.${system})
        nixvim
        recordly
        yakc
        ;
    };
}
