{
  config,
  lib,
  color,
  font,
  ...
}:

let
  cfg = config.homeTerminalModules.ghostty;
  master = config.homeTerminalModules;
  openGL = config.homeCoreModules.openGL;
  masterEnable = master.enable;
  openGLEnable = (openGL.use != "default");
  isGhostty = (master.use == "ghostty");
  inherit (color) mkTheme mkTokens;

  whenCustomWM = value: fallback: if master.enableCustomWM then value else fallback;

  mkThemeGhostty =
    {
      tokens,
      palette,
    }:
    {
      background = tokens.bg;
      foreground = tokens.fg;
      cursor-color = tokens.secondary;
      cursor-text = tokens.secondary_fg;
      selection-background = tokens.muted;
      selection-foreground = tokens.muted_fg;
      palette = palette;
    };

  theme = mkTheme master.theme;
  tokens = mkTokens theme;
in
{
  options.homeTerminalModules.ghostty = {
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
          enableZshIntegration = config.programs.zsh.enable;
          settings = {
            theme = master.theme;
            background-opacity = lib.mkDefault 0.9;
            bold-is-bright = lib.mkDefault true;
            confirm-close-surface = lib.mkDefault false;
            shell-integration-features = "no-cursor";
            cursor-style = lib.mkDefault "underline";
            cursor-click-to-move = lib.mkDefault false;
            cursor-style-blink = lib.mkDefault true;
            custom-shader-animation = lib.mkDefault true;
            desktop-notifications = lib.mkDefault true;
            font-family = font.family.monospace;
            font-size = font.sizes.terminal;
            font-feature = lib.mkDefault "liga,calt,dlig";
            font-thicken = lib.mkDefault true;
            macos-window-shadow = lib.mkDefault false;
            macos-titlebar-style = lib.mkDefault "transparent";
            window-decoration = lib.mkDefault false;
            window-padding-x = lib.mkDefault 4;
            window-padding-y = lib.mkDefault 0;
            window-padding-balance = lib.mkDefault true;
            window-padding-color = lib.mkDefault "extend";
            gtk-custom-css = "${config.xdg.configHome}/ghostty/style.css";
          };
          themes = {
            ${master.theme} = mkThemeGhostty {
              inherit tokens;
              palette = theme.lines;
            };
          };
        }
        cfg.settings
      ];
    };

    xdg.configFile."ghostty/style.css".text = (
      whenCustomWM "" ''
        window {
            border: 2px solid ${tokens.border};
            border-radius: 8px;
            margin: 4px;
        }
      ''
    );

    xdg.desktopEntries = lib.mkIf openGLEnable {
      "com.mitchellh.ghostty" = {
        name = "Ghostty";
        type = "Application";
        icon = "com.mitchellh.ghostty";
        exec = "${openGL.use} ghostty";
        comment = "A terminal emulator";
        terminal = false;
        startupNotify = true;
        actions.new-window.name = "New Window";
        actions.new-window.exec = "${openGL.use} ghostty";
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
