{ inputs, ... }:

{
  flake.overlays.packages =
    _: prev:

    let
      system = prev.stdenv.hostPlatform.system;
    in
    {
      nixvim = inputs.self.packages.${system}.nixvim;
      yakc = inputs.self.packages.${system}.yakc;
    };
}
