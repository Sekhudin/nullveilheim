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

  menus = {
    power = getVar "menus.power";
  };

  actions = {
    lock = getVar "actions.lock";
  };
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.plain "XF86PowerOff";
            dispatcher = dsp.exec_cmd {
              cmd = menus.power;
            };
            flags = {
              description = "powermenu applet";
            };
          })

          (mkBind {
            key = combos.mod "escape";
            dispatcher = dsp.exec_cmd {
              cmd = actions.lock;
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
