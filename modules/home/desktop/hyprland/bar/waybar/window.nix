{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib.hyprland) dsp;

  icons = {
    ai = ''<span size="150%"> </span>'';
    firefox = ''<span size="150%">󰈹 </span>'';
    fck = ''<span size="150%"> </span>'';
    ghostty = ''<span size="150%"> </span>'';
    neovim = ''<span size="150%"> </span>'';
    nix = ''<span size="150%"> </span>'';
  };
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
              "(.*) — Mozilla Firefox" = "${icons.firefox}$1";
              "(.*)Mozilla Firefox" = "${icons.firefox}Firefox";

              "(.*)Ghostty" = "${icons.ghostty}Ghostty";
              "^~.*" = "${icons.ghostty}Ghostty";
              "^/.*" = "${icons.ghostty}Ghostty";

              "fuck-(.*) (.*)" = "${icons.fck}$1";
              "^sysz.*" = "${icons.fck}systemctl";

              "^nvim.*" = "${icons.neovim}Neovim > I use vim btw";

              "^nix.*" = "${icons.nix}Nix > I use nix btw";
              "^sudo nix.*" = "${icons.nix}Nix > I use nix btw";
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
