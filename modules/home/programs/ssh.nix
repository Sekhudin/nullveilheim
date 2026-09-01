{
  lib,
  config,
  ...
}:

let
  cfg = config.homeProgramsModules.ssh;
  masterEnable = config.homeProgramsModules.enable;

  inherit (config.homeProgramsModules.secrets) secretProfiles;
  enableSecrets = config.homeProgramsModules.secrets.enable;
in
{
  options.homeProgramsModules.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable ssh";
      default = true;
    };

    enableShellAliases = lib.mkOption {
      type = lib.types.bool;
      description = "enable shellAliases";
      default = false;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "ssh settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs = {
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = lib.mkMerge [
          {
            "Host *" = {
              ServerAliveInterval = 60;
              ServerAliveCountMax = 3;
              ControlMaster = "auto";
              ControlPersist = "10m";
              ControlPath = "~/.ssh/control-%C";
              HashKnownHosts = true;
            };
          }
          cfg.settings
        ];
      };
    };

    home = lib.mkIf (enableSecrets && cfg.enableShellAliases) {
      shellAliases = lib.foldl' (
        acc: profile:
        acc
        // {
          "ssh-${profile}" = "ssh -i ~/.ssh/${profile}";
          "scp-${profile}" = "scp -i ~/.ssh/${profile}";
          "sftp-${profile}" = "sftp -i ~/.ssh/${profile}";
        }
      ) { } secretProfiles.sshKeys;
    };
  };
}
