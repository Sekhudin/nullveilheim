{ lib, ... }:

{
  imports = [
    ./polkit.nix
  ];

  options.nixosSecurityModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable security module";
      default = false;
    };
  };
}
