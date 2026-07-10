{
  config,
  lib,
  osConfig,
  extraLib,
  ...
}:

let
  cfg = config.homeTerminalModules.alacritty;
  master = config.homeTerminalModules;
  masterEnable = master.enable;
  useOpenGL = (master.openGL != "default");
  isAlacritty = (master.use == "alacritty");
  isStandalone = extraLib.isStandalone osConfig;
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

    xdg.desktopEntries = lib.mkIf (useOpenGL && isStandalone) {
      Alacritty = {
        name = "Alacritty";
        genericName = "Terminal";
        type = "Application";
        icon = "Alacritty";
        exec = "${master.openGL} alacritty";
        comment = "A fast, cross-platform, OpenGL terminal emulator";
        startupNotify = true;
        terminal = false;
        actions.new.name = "New Terminal";
        actions.new.exec = "${master.openGL} alacritty";
        settings.StartupWMClass = "Alacritty";
        categories = [
          "System"
          "TerminalEmulator"
        ];
      };
    };
  };
}
