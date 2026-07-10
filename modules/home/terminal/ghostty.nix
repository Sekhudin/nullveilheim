{
  config,
  lib,
  osConfig,
  extraLib,
  color,
  font,
  ...
}:

let
  cfg = config.homeTerminalModules.ghostty;
  master = config.homeTerminalModules;
  masterEnable = master.enable;
  useOpenGL = (master.openGL != "default");
  isGhostty = (master.use == "ghostty");
  isStandalone = extraLib.isStandalone osConfig;

  mkThemeGhostty = name: themeColor: {
    background = themeColor.scheme.base00;
    foreground = themeColor.scheme.base07;
    cursor-color = themeColor.scheme.base06;
    cursor-text = themeColor.scheme.base07;
    selection-background = themeColor.scheme.base08;
    selection-foreground = themeColor.scheme.base0F;
    palette = themeColor.lines;
  };

  themeNames = lib.attrNames color.themes;
  themesColor = lib.genAttrs themeNames (name: color.mkTheme name);

  themesGhostty = lib.genAttrs themeNames (name: mkThemeGhostty name themesColor.${name});
  colorGhostty = themesColor.${cfg.theme};
in
{
  options.homeTerminalModules.ghostty = {
    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      description = "theme settings";
      default = builtins.elemAt themeNames 0;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "ghostty settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isGhostty) {
    programs = {
      ghostty = lib.mkMerge [
        {
          enable = true;
          enableFishIntegration = config.programs.fish.enable;
          enableBashIntegration = config.programs.bash.enable;
          enableZshIntegration = config.programs.zsh.enable;
          settings = {
            theme = cfg.theme;
            background-opacity = lib.mkDefault 0.9;
            cursor-style = lib.mkDefault "underline";
            bold-is-bright = lib.mkDefault true;
            confirm-close-surface = lib.mkDefault false;
            cursor-click-to-move = lib.mkDefault false;
            cursor-style-blink = lib.mkDefault true;
            custom-shader-animation = lib.mkDefault true;
            desktop-notifications = lib.mkDefault true;
            font-family = font.family.monospace;
            font-feature = lib.mkDefault "liga,calt,dlig";
            font-thicken = lib.mkDefault true;
            macos-window-shadow = lib.mkDefault false;
            macos-titlebar-style = lib.mkDefault "transparent";
            window-decoration = lib.mkDefault false;
            window-padding-x = lib.mkDefault 6;
            window-padding-y = lib.mkDefault 0;
            window-padding-balance = lib.mkDefault true;
            window-padding-color = lib.mkDefault "extend";
            gtk-custom-css = "${config.xdg.configHome}/ghostty/style.css";
          };
          themes = themesGhostty;
        }
        cfg.settings
      ];
    };

    xdg.configFile."ghostty/style.css".text = ''
      window {
          border: 2px solid ${colorGhostty.scheme.base08};
          border-radius: 8px;
          margin: 4px;
        }
    '';

    xdg.desktopEntries = lib.mkIf (useOpenGL && isStandalone) {
      "com.mitchellh.ghostty" = {
        name = "Ghostty";
        type = "Application";
        icon = "com.mitchellh.ghostty";
        exec = "${master.openGL} ghostty";
        comment = "A terminal emulator";
        terminal = false;
        startupNotify = true;
        actions.new-window.name = "New Window";
        actions.new-window.exec = "${master.openGL} ghostty";
        settings.Keywords = "terminal;tty;pty";
        settings.StartupWMClass = "com.mitchellh.ghostty";
        settings.X-GNOME-UsesNotifications = "true";
        settings.X-TerminalArgExec = "-e";
        settings.X-TerminalArgTitle = "--title=";
        settings.X-TerminalArgAppId = "--class=";
        settings.X-TerminalArgDir = "--working-directory=";
        settings.X-TerminalArgHold = "--wait-after-command";
        categories = [
          "System"
          "TerminalEmulator"
        ];
      };
    };
  };
}
