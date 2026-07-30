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
    keys
    mouse
    ;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.of [
              keys.mod
              mouse.left
            ] null;
            dispatcher = dsp.window.drag { };
            flags = {
              mouse = true;
              drag = true;
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              mouse.right
            ] null;
            dispatcher = dsp.window.resize { };
            flags = {
              mouse = true;
              drag = true;
            };
          })
        ];
      };
    };
  };
}
