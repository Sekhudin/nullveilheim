{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeProgramsModules.gpg;
  masterEnable = config.homeProgramsModules.enable;
  pinentryPkg = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
in
{
  options.homeProgramsModules.gpg = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable gpg";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "gpg settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs = {
      gpg = lib.mkMerge [
        {
          enable = true;
          settings = {
            use-agent = true;
          };
        }
        cfg.settings
      ];
    };

    services = {
      gpg-agent = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
        enableZshIntegration = config.programs.zsh.enable;
        enableSshSupport = true;
        defaultCacheTtl = 3600;
        maxCacheTtl = 999999;
        pinentry = {
          package = pinentryPkg;
        };
      };
    };
  };
}
