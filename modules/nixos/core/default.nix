{ lib, ... }:

{
  imports = [
    ./boot.nix
    ./i18n.nix
    ./networking.nix
    ./nix.nix
    ./nixpkgs.nix
    ./time.nix
  ];

  options.nixosCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable core modules";
      default = true;
    };
  };
}
