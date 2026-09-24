{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) mkWindowRule;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        window_rule = [
          (mkWindowRule {
            name = "yakc";
            match = {
              class = "^Yakc$";
            };
            pin = true;
            no_focus = true;
            no_blur = true;
            no_shadow = true;
            no_anim = true;
          })
        ];
      };
    };
  };
}
