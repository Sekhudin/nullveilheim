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
    mkWorkspaceBind
    dsp
    combos
    keys
    ;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = mkWorkspaceBind {
          count = 9;
          extraBind = [
            (mkBind {
              key = combos.mod "TAB";
              dispatcher = dsp.focus {
                workspace = "+1";
              };
            })

            (mkBind {
              key = combos.of [
                keys.mod
                keys.shift
              ] "TAB";
              dispatcher = dsp.focus {
                workspace = "-1";
              };
            })
          ];
        };
      };
    };
  };
}
