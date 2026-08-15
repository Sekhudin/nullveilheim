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
    getVar
    dsp
    combos
    keys
    ;

  lock = getVar "actions.lock";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "escape";
            dispatcher = dsp.exec_cmd {
              cmd = lock;
            };
            flags = {
              description = "lock screen";
            };
          })

          (mkBind {
            key = combos.of [
              keys.mod
              keys.shift
            ] "E";
            dispatcher = dsp.exit { };
            flags = {
              description = "logout session";
            };
          })
        ];
      };
    };
  };
}
