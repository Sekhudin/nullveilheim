{
  config,
  lib,
  color,
  font,
  ...
}:

let
  cfg = config.homeTerminalModules.alacritty;
  master = config.homeTerminalModules;
  openGL = config.homeCoreModules.openGL;
  masterEnable = master.enable;
  openGLEnable = (openGL.use != "default");
  isAlacritty = (master.use == "alacritty");
  inherit (color) mkTokens;

  tokens = mkTokens config.homeCoreModules.theme;
in
{
  options.homeTerminalModules.alacritty = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "alacritty settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isAlacritty) {
    programs = {
      alacritty = lib.mkMerge [
        {
          enable = true;
          settings = {
            window = {
              startup_mode = "Windowed";
              decorations = "none";
              opacity = color.opacity;
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
              size = font.sizes.terminal;
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
                background = tokens.bg;
                foreground = tokens.fg;
              };
              cursor = {
                cursor = tokens.secondary;
                text = tokens.secondary_fg;
              };
              selection = {
                background = tokens.muted;
                text = tokens.muted_fg;
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
        }
        cfg.settings
      ];
    };

    xdg.desktopEntries = lib.mkIf openGLEnable {
      Alacritty = {
        name = "Alacritty";
        genericName = "Terminal";
        type = "Application";
        icon = "Alacritty";
        exec = "${openGL.use} alacritty";
        comment = "A fast, cross-platform, OpenGL terminal emulator";
        startupNotify = true;
        terminal = false;
        actions.new.name = "New Terminal";
        actions.new.exec = "${openGL.use} alacritty";
        settings.StartupWMClass = "Alacritty";
        categories = [
          "System"
          "TerminalEmulator"
        ];
      };
    };
  };
}
