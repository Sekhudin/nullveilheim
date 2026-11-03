{
  config,
  pkgs,
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

  hardware = {
    bluetooth = {
      enable = cfg.enable;
      powerOnBoot = true;
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
    udev = {
      packages = [
        (pkgs.writeTextFile {
          name = "openscreen-mouse-udev-rules";
          destination = "/lib/udev/rules.d/70-openscreen-mouse.rules";
          text = ''
            KERNEL=="event*", SUBSYSTEM=="input", ENV{ID_INPUT_MOUSE}=="1", ENV{ID_INPUT_KEYBOARD}!="1", TAG+="uaccess"
            KERNEL=="event*", SUBSYSTEM=="input", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{ID_INPUT_KEYBOARD}!="1", TAG+="uaccess"
          '';
        })
      ];
    };
  };
}
