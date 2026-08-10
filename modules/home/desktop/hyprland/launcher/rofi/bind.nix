{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland)
    mkBind
    dsp
    combos
    ;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "D";
            dispatcher = dsp.exec_cmd {
              cmd = "rofi -show drun";
            };
            flags = {
              release = true;
            };
          })
        ];
      };
    };
  };
}
