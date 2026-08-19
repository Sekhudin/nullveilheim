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

  menus = {
    apps = getVar "menus.apps";
    binds = getVar "menus.binds";
    power = getVar "menus.power";
  };
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "SUPER_L";
            dispatcher = dsp.exec_cmd {
              cmd = menus.apps;
            };
            flags = {
              release = true;
              description = "show apps";
            };
          })

          (mkBind {
            key = combos.mod "SLASH";
            dispatcher = dsp.exec_cmd {
              cmd = menus.binds;
            };
            flags = {
              description = "show key bindings";
            };
          })

          (mkBind {
            key = combos.mod "escape";
            dispatcher = dsp.exec_cmd {
              cmd = menus.power;
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
