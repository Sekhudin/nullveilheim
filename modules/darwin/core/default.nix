{ lib, ... }:

{
  imports = [
    ./nix.nix
    ./nixpkgs.nix
  ];

  options.darwinCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable core modules";
      default = true;
    };
  };
}
