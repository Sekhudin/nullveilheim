{ lib, ... }:

{
  imports = [
    ./boot.nix
    ./home-manager.nix
    ./i18n.nix
    ./networking.nix
    ./time.nix
  ];

  options.nixosCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable core modules";
      default = false;
    };
  };
}
