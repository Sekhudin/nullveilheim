{ inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages = pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      yakc = pkgs.callPackage ./yakc.nix {
        src = inputs.yakc-src;
      };
    };
  };
}
