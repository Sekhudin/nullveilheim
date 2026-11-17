{ lib, extraLib, ... }:

let
  inherit (extraLib.hyprland) hypr;
  mkMatchRegex = patterns: "(?i)^(${lib.concatStringsSep "|" patterns})$";
in
{
  wayland.windowManager.hyprland = {
    settings.window_rule = [
      (hypr.mkWindowRule {
        name = "maximize-by-class";
        match.class = mkMatchRegex [
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
        ];
        float = false;
        maximize = true;
      })

      (hypr.mkWindowRule {
        name = "float-by-class";
        match.class = mkMatchRegex [
          "org.gnupg.pinentry-qt"
        ];
        float = true;
        maximize = false;
      })

      (hypr.mkWindowRule {
        name = "float-unfocused-by-class";
        match.class = mkMatchRegex [
          "java"
        ];
        float = true;
        no_focus = true;
        maximize = false;
        border_size = 0;
      })

      (hypr.mkWindowRule {
        name = "float-unfocused-by-title";
        match.title = mkMatchRegex [
          "discord updater"
          "Steam"
        ];
        float = true;
        no_focus = true;
        maximize = false;
        border_size = 0;
      })

      (hypr.mkWindowRule {
        name = "disable-effects-for-floating";
        match.float = true;
        no_blur = true;
        no_shadow = true;
      })
    ];
  };
}
