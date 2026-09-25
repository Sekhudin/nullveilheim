{
  config,
  lib,
  font,
  ...
}:

let
  core = config.homeCore;
  theme = core.themeConfig;
  configHome = config.xdg.configHome;
in
{
  programs.ghostty = {
    enable = core.terminal == "ghostty";
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
      theme = theme.name;
      background-opacity = theme.opacity;
      bold-is-bright = true;
      confirm-close-surface = false;
      shell-integration-features = "no-cursor";
      cursor-style = "underline";
      cursor-click-to-move = false;
      cursor-style-blink = true;
      custom-shader-animation = true;
      desktop-notifications = true;
      font-family = font.family.monospace;
      font-size = font.sizes.terminal;
      font-feature = "liga,calt,dlig";
      font-thicken = true;
      macos-window-shadow = false;
      macos-titlebar-style = "transparent";
      window-decoration = false;
      window-padding-x = 4;
      window-padding-y = 0;
      window-padding-balance = true;
      window-padding-color = "extend";
      gtk-custom-css = "${configHome}/ghostty/style.css";
    };
    themes = {
      ${theme.name} = theme.apps.ghostty;
    };
  };

  xdg = lib.mkIf (core.terminal == "ghostty") {
    configFile = {
      "ghostty/style.css".text = (
        if config.wayland.windowManager.hyprland.enable then
          ""
        else
          ''
            window {
                border: 2px solid ${theme.tokens.border};
                border-radius: 8px;
                margin: 4px;
            }
          ''
      );
    };

    desktopEntries = lib.mkIf (core.opengl != "") {
      "com.mitchellh.ghostty" = {
        name = "Ghostty";
        type = "Application";
        icon = "com.mitchellh.ghostty";
        exec = "${core.opengl} ghostty";
        comment = "A terminal emulator";
        terminal = false;
        startupNotify = true;
        actions.new-window.name = "New Window";
        actions.new-window.exec = "${core.opengl} ghostty";
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
