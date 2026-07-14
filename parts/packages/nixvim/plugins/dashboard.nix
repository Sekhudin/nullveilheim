{
  config,
  lib,
  extraLib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.dashboard;
  inherit (extraLib.nixvim) asciiArts mkAsciiHeader mkAsciiFooter;

  isTheme = theme: cfg.theme == theme;
  asciiArtNames = builtins.attrNames asciiArts;
  shortcut = [
    {
      key = "Fn";
      icon = (icon.withRightSpace "plus_1");
      desc = "New File ";
      action = "new";
    }
    {
      key = "Ff";
      icon = (icon.withRightSpace "file");
      desc = "Find File ";
      action = "Telescope find_files";
    }
    {
      key = "Fw";
      icon = "${icon.word} ";
      desc = "Find Word ";
      action = "Telescope live_grep";
    }
  ];

  mkSpacer = gap: lib.lists.replicate gap "";
  header =
    (
      if cfg.banner.header.custom != null then
        cfg.banner.header.custom
      else
        (mkAsciiHeader {
          inherit (cfg.banner.header) head;
          ascii = asciiArts.${cfg.banner.header.ascii}.art;
        })
    )
    ++ (mkSpacer cfg.banner.header.gap);

  footer =
    (mkSpacer cfg.banner.header.gap)
    ++ (
      if cfg.banner.footer.custom != null then
        cfg.banner.footer.custom
      else
        (mkAsciiFooter {
          inherit (cfg.banner.footer) tail;
          ascii = asciiArts.${cfg.banner.footer.ascii}.art;
        })
    );
in
{
  options.pluginsModules.dashboard = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable dashboard";
      default = false;
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

    banner = lib.mkOption {
      type = lib.types.submodule {
        options = {
          header = lib.mkOption {
            type = lib.types.submodule {
              options = {
                ascii = lib.mkOption {
                  type = lib.types.enum asciiArtNames;
                  description = "choose ascii art";
                  default = "absolute_cinema";
                };
                head = lib.mkOption {
                  type = lib.types.nullOr lib.types.int;
                  description = "asciii selector";
                  default = 15;
                };
                gap = lib.mkOption {
                  type = lib.types.int;
                  description = "bottom gap";
                  default = 0;
                };
                custom = lib.mkOption {
                  type = lib.types.nullOr (lib.types.listOf lib.types.str);
                  description = "custom header";
                  default = null;
                };
              };
            };
          };

          footer = lib.mkOption {
            type = lib.types.submodule {
              options = {
                ascii = lib.mkOption {
                  type = lib.types.enum asciiArtNames;
                  description = "choose ascii art";
                  default = "absolute_cinema";
                };
                tail = lib.mkOption {
                  type = lib.types.nullOr lib.types.int;
                  description = "ascii selector";
                  default = 5;
                };
                gap = lib.mkOption {
                  type = lib.types.int;
                  description = "bottom gap";
                  default = 0;
                };
                custom = lib.mkOption {
                  type = lib.types.nullOr (lib.types.listOf lib.types.str);
                  description = "custom footer";
                  default = null;
                };
              };
            };
          };
        };
      };
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
              inherit header footer;
              disable_move = lib.mkDefault true;
              week_header = {
                enable = lib.mkDefault false;
              };
            };
          };
        }

        (lib.mkIf (isTheme "doom") {
          settings = {
            config = {
              vertical_center = lib.mkDefault true;
              center = shortcut;
            };
          };
        })

        (lib.mkIf (isTheme "hyper") {
          settings = {
            config = {
              inherit shortcut;

              project = {
                enable = lib.mkDefault true;
                limit = lib.mkDefault 3;
              };

              mru = {
                enable = lib.mkDefault true;
                limit = lib.mkDefault 3;
                cwd_only = lib.mkDefault true;
              };

              packages = {
                enable = lib.mkDefault false;
              };
            };
          };
        })

        cfg.settings
      ];
    };
  };
}
