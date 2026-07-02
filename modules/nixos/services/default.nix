{ lib, ... }:

{
  imports = [
    ./openssh.nix
    ./printing.nix
  ];

  options.nixosServicesModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "activate service module";
      default = true;
    };
  };
}
