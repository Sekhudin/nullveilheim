{
  config,
  lib,
  ...
}:

let
  core = config.homeCore;
  desktop = config.homeDesktop;
  theme = core.themeConfig;
  font = core.font;
  configHome = config.xdg.configHome;
in
{
  programs.ghostty = {
    enable = core.terminal == "ghostty";
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
      theme = if desktop.enable then desktop.use else theme.name;
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
      font-size = font.sizes.base;
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
    configFile = lib.mkIf (!desktop.enable) {
      "ghostty/style.css".text = ''
        window {
            border: 2px solid ${theme.tokens.border};
            border-radius: 8px;
            margin: 4px;
        }
      '';
    };
  };
}
