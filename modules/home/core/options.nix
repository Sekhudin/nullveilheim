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

  iconType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "name of icon theme.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        description = "icon theme package";
      };
    };
  };

  cursorType = lib.types.submodule {
    options = {
      theme = lib.mkOption {
        type = lib.types.str;
        description = "name of the cursor theme.";
      };
      size = lib.mkOption {
        type = lib.types.ints.positive;
        description = "cursor size in pixels.";
      };
      package = lib.mkOption {
        type = lib.types.package;
        description = "package providing the cursor theme.";
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

    icon = lib.mkOption {
      type = iconType;
      default = {
        name = "Papirus Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    cursor = lib.mkOption {
      type = cursorType;
      description = "cursor theme";
      default = {
        package = pkgs.bibata-cursors;
        theme = "Bibata-Modern-Ice";
        size = 24;
      };
    };
  };

  config = {
    home = {
      packages = [
        core.icon.package
        core.cursor.package
      ];
    };

    homeCore = {
      themeConfig = color.mkTheme core.theme;
    };
  };
}
