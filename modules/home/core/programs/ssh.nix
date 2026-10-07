{
  lib,
  config,
  ...
}:

let
  cfg = config.homeCore.programs.ssh;
in
{
  options.homeCore.programs.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable ssh";
      default = true;
    };
  };

  config = {
    programs.ssh = {
      enable = cfg.enable;
      enableDefaultConfig = false;
      settings = {
        "Host *" = {
          ServerAliveInterval = 60;
          ServerAliveCountMax = 3;
          ControlMaster = "auto";
          ControlPersist = "10m";
          ControlPath = "~/.ssh/control-%C";
          HashKnownHosts = true;
        };
      };
    };
  };
}
