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
    ;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          # logout
          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "E";
            dispatcher = dsp.exit { };
            flags = {
              description = "logout";
            };
          })

          # reload
          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "R";
            dispatcher = dsp.exec_cmd {
              cmd = "hyprctl reload";
            };
            flags = {
              description = "reload config";
            };
          })
        ];
      };
    };
  };
}
