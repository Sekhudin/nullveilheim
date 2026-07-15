{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.ui;
in
{
  plugins = lib.mkIf cfg.enable {
    colorizer = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
        };
      };
      settings = {
        user_default_options = {
          mode = "virtualtext";
          virtualtext = " ■";
          RRGGBBAA = true;
          RRGGBB = true;
          AARRGGBB = true;
        };
      };
    };

    cursorline = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
        };
      };
      settings = {
        cursorline = {
          enable = true;
          number = true;
          timeout = 0;
        };
        cursorword = {
          enable = true;
          hl = {
            underline = false;
          };
        };
      };
    };

    mini-icons = {
      enable = true;
      mockDevIcons = true;
      settings = {
        style = "glyph";
        default = { };
        directory = { };
        extension = { };
        file = { };
        filetype = { };
        lsp = { };
        os = { };
      };
    };

    which-key = {
      settings = {
        spec = [
        ];
      };
    };
  };
}
