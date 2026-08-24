{ lib, ... }:

{
  imports = [
    ./audio.nix
    ./openssh.nix
    ./printing.nix
    ./tailscale.nix
    ./virtualisation.nix
  ];

  options.nixosServicesModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable service module";
      default = false;
    };
  };

  config = {
    services = {
      logind = {
        enable = true;
        settings = {
          Login = {
            HandlePowerKey = "ignore";
            HandleLidSwitch = "ignore";
            KillUserProcesses = false;
          };
        };
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
