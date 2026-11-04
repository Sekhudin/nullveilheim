{ lib, extraLib, ... }:

let
  inherit (extraLib.hyprland) hypr;
in
{
  wayland.windowManager.hyprland = {
    settings.window_rule = [
      (hypr.mkWindowRule {
        name = "maximize-window";
        match = {
          class = "(?i)^(${
            lib.concatStringsSep "|" [
              "DBeaver"
              "discord"
              "slack"
              "wps"
              "wpp"
              "pdf"
              "et"
              "jetbrains-studio"
              "com.obsproject.Studio"
              "md.obsidian.Obsidian"
              "org.telegram.desktop"
            ]
          })$";
        };
        float = false;
        maximize = true;
      })

      (hypr.mkWindowRule {
        name = "loader-window-by-class";
        match = {
          class = "(?i)^(${
            lib.concatStringsSep "|" [
              "java"
            ]
          })$";
        };
        float = true;
        no_focus = true;
        maximize = false;
        border_size = 0;
      })

      (hypr.mkWindowRule {
        name = "loader-window-by-title";
        match = {
          title = "(?i)^(${
            lib.concatStringsSep "|" [
              "discord updater"
              "Steam"
            ]
          })$";
        };
        float = true;
        no_focus = true;
        maximize = false;
        border_size = 0;
      })

      (hypr.mkWindowRule {
        name = "float-window";
        match = {
          float = true;
        };
        no_blur = true;
        no_shadow = true;
      })
    ];
  };
}
