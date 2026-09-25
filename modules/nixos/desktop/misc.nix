{
  config,
  ...
}:

let
  cfg = config.nixosDesktop;
in
{
  networking = {
    networkmanager = {
      enable = cfg.enable;
    };
  };

  services = {
    gvfs = {
      enable = cfg.enable;
    };
    udisks2 = {
      enable = cfg.enable;
    };
    upower = {
      enable = cfg.enable;
    };
    power-profiles-daemon = {
      enable = cfg.enable;
    };
    printing = {
      enable = cfg.enable;
    };
    logind = {
      enable = cfg.enable;
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
  };

  hardware = {
    bluetooth = {
      enable = cfg.enable;
      powerOnBoot = true;
    };
  };
}
