{
  config,
  lib,
  ...
}:

let
  cfg = config.homeTerminalModules.alacritty;
  master = config.homeTerminalModules;
  openGL = config.homeOpenGLModules;
  masterEnable = master.enable;
  openGLEnable = (openGL.enable && openGL.use != "default");
  isAlacritty = (master.use == "alacritty");
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
              dimensions = {
                columns = 0;
                lines = 0;
              };
              padding = {
                x = 0;
                y = 0;
              };
              opacity = 0.9;
              startup_mode = "Windowed";
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
