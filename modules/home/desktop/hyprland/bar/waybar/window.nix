{
  config,
  lib,
  extraLib,
  icon,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib.hyprland) dsp;
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "hyprland/window" = {
            format = "{}";
            max-length = 30;
            separate-outputs = true;
            icon = false;
            icon-size = 12;
            expand = false;
            tooltip = false;
            rewrite = {
              "(.*) — Mozilla Firefox" = "${icon.firefox} $1";

              "(.*)Mozilla Firefox" = "${icon.firefox} Firefox";
              "(.*)Ghostty" = "${icon.ghostty} Ghostty";

              "^~.*" = "${icon.ghostty} Ghostty";
              "^/.*" = "${icon.ghostty} Ghostty";
              "^nvim.*" = "${icon.neovim} Neovim > I use vim btw";
              "^nix.*" = "${icon.lang_nix} Nix > I use nix btw";
            };
            on-double-click = "hyprctl dispatch '${
              dsp.window.fullscreen {
                mode = "maximized";
                action = "toggle";
                layout_aware = true;
              }
            }'";
          };
        };
        secondary = primary;
      };
    };
  };
}
