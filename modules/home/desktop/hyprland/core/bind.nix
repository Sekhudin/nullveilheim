{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) mkBind combos;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "Q";
            dispatcher = "hl.dsp.window.close()";
            flags = {
              locked = true;
            };
          })

          (mkBind {
            type = "exec_cmd";
            raw = true;
            key = combos.mod "RETURN";
            dispatcher = "terminal";
          })

          (mkBind {
            type = "exec_cmd";
            raw = true;
            key = combos.mod "B";
            dispatcher = "browser";
          })

          (mkBind {
            type = "submap";
            key = combos.alt "R";
            dispatcher = "resize";
          })
        ];
      };
    };
  };
}
