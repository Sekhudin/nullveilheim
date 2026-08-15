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
    ;

  apps = getVar "menus.apps";
  binds = getVar "menus.binds";
  power = getVar "menus.power";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "SUPER_L";
            dispatcher = dsp.exec_cmd {
              cmd = apps;
            };
            flags = {
              release = true;
              description = "show apps";
            };
          })

          (mkBind {
            key = combos.mod "SLASH";
            dispatcher = dsp.exec_cmd {
              cmd = binds;
            };
            flags = {
              description = "show key bindings";
            };
          })

          (mkBind {
            key = combos.mod "escape";
            dispatcher = dsp.exec_cmd {
              cmd = power;
            };
            flags = {
              description = "show powermenu";
            };
          })
        ];
      };
    };
  };
}
