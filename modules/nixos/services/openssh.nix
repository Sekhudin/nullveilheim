{ config, lib, ... }:

let
  cfg = config.nixosServicesModules.openssh;
  masterEnable = config.nixosServicesModules.enable;
in
{
  options.nixosServicesModules.openssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable openssh service";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "openssh settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    services = {
      openssh = lib.mkMerge [
        {
          enable = true;
          ports = lib.mkDefault [ 22 ];
          openFirewall = lib.mkDefault false;
          settings = {
            PasswordAuthentication = lib.mkDefault false;
            PermitRootLogin = lib.mkDefault "no";
            X11Forwarding = lib.mkDefault true;
            X11DisplayOffset = lib.mkDefault 10;
          };
        }
        cfg.settings
      ];
    };
  };
}
