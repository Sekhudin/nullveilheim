{
  pkgs,
  config,
  lib,
  color,
  ...
}:

let
  core = config.homeCore;
  themeNames = lib.attrNames color.themes;
  themeConfigType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.enum themeNames;
        description = "name of the theme.";
      };
      colors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "raw theme colors.";
      };
      palette = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "theme colors formatted as a palette.";
      };
      scheme = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "theme color scheme mapped by base color names.";
      };
      tokens = lib.mkOption {
        type = lib.types.attrs;
        description = "semantic design tokens derived from the theme colors.";
      };
      apps = lib.mkOption {
        type = lib.types.attrs;
        description = "application-specific theme configurations.";
      };
      opacity = lib.mkOption {
        type = lib.types.float;
        description = "theme opacity from 0.0 to 1.0.";
      };
    };
  };

  fontType = lib.types.submodule {
    options = {
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "font packages.";
        default = with pkgs; [
          inter
          nerd-fonts.jetbrains-mono
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-cjk-sans
        ];
      };
      family = lib.mkOption {
        type = lib.types.submodule {
          options = {
            monospace = lib.mkOption {
              type = lib.types.str;
              description = "monospace font family.";
              default = "JetBrainsMono Nerd Font";
            };
            sans_serif = lib.mkOption {
              type = lib.types.str;
              description = "sans-serif font family.";
              default = "Inter";
            };
            serif = lib.mkOption {
              type = lib.types.str;
              description = "serif font family.";
              default = "Noto Serif";
            };
            emoji = lib.mkOption {
              type = lib.types.str;
              description = "emoji font family.";
              default = "Noto Color Emoji";
            };
          };
        };
        description = "font family configuration.";
        default = { };
      };
      sizes = lib.mkOption {
        type = lib.types.submodule {
          options = {
            xs = lib.mkOption {
              type = lib.types.float;
              description = "extra-small font size.";
              default = 9.0;
            };
            sm = lib.mkOption {
              type = lib.types.float;
              description = "small font size.";
              default = 10.0;
            };
            base = lib.mkOption {
              type = lib.types.float;
              description = "base font size.";
              default = 11.0;
            };
            lg = lib.mkOption {
              type = lib.types.float;
              description = "large font size.";
              default = 13.0;
            };
            xl = lib.mkOption {
              type = lib.types.float;
              description = "extra-large font size.";
              default = 16.0;
            };
          };
        };
        description = "font size scale.";
        default = { };
      };
    };
  };

  iconType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "name of icon theme.";
        default = "Papirus Dark";
      };
      package = lib.mkOption {
        type = lib.types.package;
        description = "icon theme package";
        default = pkgs.papirus-icon-theme;
      };
    };
  };

  cursorType = lib.types.submodule {
    options = {
      theme = lib.mkOption {
        type = lib.types.str;
        description = "name of the cursor theme.";
        default = "Bibata-Modern-Ice";
      };
      package = lib.mkOption {
        type = lib.types.package;
        description = "package providing the cursor theme.";
        default = pkgs.bibata-cursors;
      };
      size = lib.mkOption {
        type = lib.types.ints.positive;
        description = "cursor size in pixels.";
        default = 24;
      };
    };
  };
in
{
  options.homeCore = {
    activation = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation script";
      default = true;
    };

    standalone = lib.mkOption {
      type = lib.types.bool;
      description = "enable standalone";
      default = false;
    };

    opengl = lib.mkOption {
      type = lib.types.enum [
        ""
        "nixGLMesa"
        "nixGLIntel"
      ];
      description = "choose opengl";
      default = "";
    };

    shell = lib.mkOption {
      type = lib.types.enum [
        "fish"
        "zsh"
      ];
      description = "choose shell";
      default = "fish";
    };

    terminal = lib.mkOption {
      type = lib.types.enum [
        "ghostty"
        "alacritty"
      ];
      description = "choose terminal";
      default = "ghostty";
    };

    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      description = "theme settings";
      default = builtins.elemAt themeNames 0;
    };

    themeConfig = lib.mkOption {
      type = themeConfigType;
      description = "resolved theme configuration.";
      readOnly = true;
      internal = true;
    };

    font = lib.mkOption {
      type = fontType;
      description = "font settings";
      default = { };
    };

    icon = lib.mkOption {
      type = iconType;
      description = "icon theme";
      default = { };
    };

    cursor = lib.mkOption {
      type = cursorType;
      description = "cursor theme";
      default = { };
    };
  };

  config = {
    home = {
      packages = core.font.packages ++ [
        core.icon.package
        core.cursor.package
      ];
    };

    homeCore = {
      themeConfig = color.mkTheme core.theme;
    };
  };
}
