{ lib, ... }:

{
  imports = [
    ./audio.nix
    ./openssh.nix
    ./printing.nix
    ./virtualisation.nix
  ];

  options.nixosServicesModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable service module";
      default = false;
    };
  };
}
