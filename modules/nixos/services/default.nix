{ lib, extraLib, ... }:

let
  inherit (extraLib) mkImports;
in
{
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  options.nixosServicesModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable service module";
      default = false;
    };
  };

  config = {
    services = {
      gvfs = {
        enable = true;
      };

      logind = {
        enable = true;
        settings = {
          Login = {
            HandlePowerKey = "ignore";
            HandleLidSwitch = "ignore";
            HandleSuspendKey = "ignore";
            HandleHibernateKey = "ignore";
            KillUserProcesses = false;
          };
        };
      };

      udisks2 = {
        enable = true;
      };

      upower = {
        enable = true;
      };

      power-profiles-daemon = {
        enable = true;
      };
    };
  };
}
