{
  lib,
  config,
  ...
}:

let
  cfg = config.homeCore.programs.ssh;
  secrets = config.homeCore.programs.secrets;
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

    home = lib.mkIf (secrets.enable && cfg.enable) {
      shellAliases = lib.foldl' (
        acc: profile:
        acc
        // {
          "ssh-${profile}" = "ssh -i ~/.ssh/${profile}";
          "scp-${profile}" = "scp -i ~/.ssh/${profile}";
          "sftp-${profile}" = "sftp -i ~/.ssh/${profile}";
        }
      ) { } secrets.sshKeys;
    };
  };
}
