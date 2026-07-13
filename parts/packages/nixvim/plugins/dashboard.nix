{
  config,
  lib,
  extraLib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.dashboard;
  inherit (extraLib.nixvim) asciiArts mkAsciiHeader;

  isTheme = theme: cfg.theme == theme;
in
{
  options.pluginsModules.dashboard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable dashboard";
      default = true;
    };

    theme = lib.mkOption {
      type = lib.types.enum [
        "doom"
        "hyper"
      ];
      description = "choose theme";
      default = "hyper";
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      description = "choose theme";
      default = "~";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "dashboard settings";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      dashboard = lib.mkMerge [
        {
          enable = true;
          settings = {
            theme = cfg.theme;
            hide = {
              tabline = lib.mkDefault true;
              statusline = lib.mkDefault true;
              winbar = lib.mkDefault true;
            };
            config = {
              disable_move = lib.mkDefault true;
              header = lib.mkDefault (mkAsciiHeader asciiArts.hydra.art);
              week_header = {
                enable = lib.mkDefault false;
              };
              center = [
                {
                  key = "fn";
                  icon = (icon.withRightSpace "plus_1");
                  desc = "New File ";
                  action = "new";
                }
                {
                  key = "ff";
                  icon = (icon.withRightSpace "file");
                  desc = "Find File ";
                  action = "Telescope find_files";
                }
                {
                  key = "cn";
                  icon = (icon.withRightSpace "lang_nix");
                  desc = "Nix Config ";
                  action = "Neotree dir=${cfg.configDir}";
                }
              ];
            };
          };
        }

        (lib.mkIf (isTheme "doom") {
          settings = {
            config = {
              vertical_center = true;
            };
          };
        })

        (lib.mkIf (isTheme "hyper") {
          settings = {
            config = {
              project = {
                enable = true;
                limit = 3;
              };

              mru = {
                enable = true;
                limit = 5;
                cwd_only = true;
              };

              packages = {
                enable = false;
              };
            };
          };
        })

        cfg.settings
      ];
    };
  };
}
