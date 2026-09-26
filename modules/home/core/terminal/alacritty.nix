{
  config,
  lib,
  ...
}:

let
  core = config.homeCore;
  theme = core.themeConfig;
  font = core.font;
in
{
  programs.alacritty = {
    enable = core.terminal == "alacritty";
    settings = {
      window = {
        startup_mode = "Windowed";
        decorations = "none";
        opacity = theme.opacity;
        blur = true;
        dimensions = {
          columns = 0;
          lines = 0;
        };
        padding = {
          x = 0;
          y = 0;
        };
      };

      font = rec {
        size = font.sizes.base;
        normal = {
          family = font.family.monospace;
          style = "Regular";
        };
        bold = {
          family = normal.family;
          style = "Bold";
        };
        italic = {
          family = normal.family;
          style = "Italic";
        };
        bold_italic = {
          family = normal.family;
          style = "Bold Italic";
        };
      };

      colors = {
        primary = {
          background = theme.tokens.bg;
          foreground = theme.tokens.fg;
        };
        cursor = {
          cursor = theme.tokens.secondary;
          text = theme.tokens.secondary_fg;
        };
        selection = {
          background = theme.tokens.muted;
          text = theme.tokens.muted_fg;
        };
      };

      cursor = {
        style = {
          shape = "Underline";
          blinking = "On";
        };
      };

      mouse = {
        hide_when_typing = true;
      };
    };
  };

  xdg.desktopEntries = lib.mkIf (core.terminal == "alacritty" && core.opengl != "") {
    Alacritty = {
      name = "Alacritty";
      genericName = "Terminal";
      type = "Application";
      icon = "Alacritty";
      exec = "${core.opengl} alacritty";
      comment = "A fast, cross-platform, OpenGL terminal emulator";
      startupNotify = true;
      terminal = false;
      actions.new.name = "New Terminal";
      actions.new.exec = "${core.opengl} alacritty";
      settings.StartupWMClass = "Alacritty";
      categories = [
        "System"
        "TerminalEmulator"
      ];
    };
  };
}
