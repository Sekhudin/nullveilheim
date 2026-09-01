{ lib, ... }:

{
  options.nixvimUI = {
    cursor = lib.mkOption {
      type = lib.types.enum [
        "smear-cursor"
      ];
      description = "choose motion";
      default = "smear-cursor";
    };

    diagnostic = lib.mkOption {
      type = lib.types.enum [
        "trouble"
      ];
      description = "choose diagnostic";
      default = "trouble";
    };

    focus = lib.mkOption {
      type = lib.types.enum [
        "zen-mode"
      ];
      description = "choose focus";
      default = "zen-mode";
    };

    fold = lib.mkOption {
      type = lib.types.enum [
        "nvim-ufo"
      ];
      description = "choose fold";
      default = "nvim-ufo";
    };

    indent = lib.mkOption {
      type = lib.types.enum [
        "indent-blankline"
      ];
      description = "choose indent";
      default = "indent-blankline";
    };

    overlay = lib.mkOption {
      type = lib.types.enum [
        "noice"
      ];
      description = "choose overlay";
      default = "noice";
    };

    sidebar = lib.mkOption {
      type = lib.types.enum [
        "neo-tree"
        "nvim-tree"
      ];
      description = "choose sidebar";
      default = "neo-tree";
    };

    status = lib.mkOption {
      type = lib.types.enum [
        "lualine"
      ];
      description = "choose status";
      default = "lualine";
    };

    syntax = lib.mkOption {
      type = lib.types.enum [
        "rainbow-delimiters"
      ];
      description = "choose syntax highlighting";
      default = "rainbow-delimiters";
    };

    tab = lib.mkOption {
      type = lib.types.enum [
        "bufferline"
      ];
      description = "choose tab";
      default = "bufferline";
    };
  };

  config = {
    plugins = {
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
  };
}
