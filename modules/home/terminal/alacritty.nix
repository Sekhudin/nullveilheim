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

  themesColor = lib.genAttrs (lib.attrNames color.themes) (name: color.mkTheme name);
  colorTerminal = themesColor.${master.theme};
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
              opacity = 0.95;
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

            font = {
              size = font.sizes.terminal;
              normal = {
                family = font.family.monospace;
                style = "Regular";
              };
              bold = {
                family = font.family.monospace;
                style = "Bold";
              };
              italic = {
                family = font.family.monospace;
                style = "Italic";
              };
              bold_italic = {
                family = font.family.monospace;
                style = "Bold Italic";
              };
            };

            colors = {
              primary = {
                background = colorTerminal.scheme.base00;
                foreground = colorTerminal.scheme.base07;
              };
              cursor = {
                cursor = colorTerminal.scheme.base06;
                text = colorTerminal.scheme.base07;
              };
              selection = {
                text = colorTerminal.scheme.base0F;
                background = colorTerminal.scheme.base08;
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
