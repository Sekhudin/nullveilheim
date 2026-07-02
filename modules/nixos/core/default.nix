{ lib, ... }:

{
  imports = [
    ./boot.nix
    ./i18n.nix
    ./networking.nix
    ./time.nix
  ];

  options.nixosCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "activate core modules";
      default = false;
    };
  };
}
