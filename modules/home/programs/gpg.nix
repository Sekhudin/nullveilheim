{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeProgramsModules.gpg;
  masterEnable = config.homeProgramsModules.enable;
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

    home.file.".gnupg/gpg-agent.conf" = lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isDarwin {
        text = ''
          pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
          default-cache-ttl 3600
          max-cache-ttl 999999
        '';
      })

      (lib.mkIf pkgs.stdenv.isLinux {
        text = ''
          pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
          default-cache-ttl 3600
          max-cache-ttl 999999
        '';
      })
    ];
  };
}
