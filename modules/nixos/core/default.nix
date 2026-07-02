{ lib, ... }:

{
  imports = [
    ./boot.nix
    ./i18n.nix
  ];

  options.nixosCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "activate core modules";
      default = false;
    };
  };
}
