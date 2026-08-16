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
    mkSubmap
    mkSubmapBind
    getVar
    dsp
    combos
    ;

  session = getVar "submaps.session";
  lock = getVar "actions.lock";
  logout = getVar "actions.logout";
  poweroff = getVar "actions.poweroff";
  reboot = getVar "actions.reboot";
  suspend = getVar "actions.suspend";

  mkDesc = desc: "(S) ${desc}";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.alt "S";
            dispatcher = dsp.submap {
              name = session;
            };
            flags = {
              description = mkDesc "enter submap session";
            };
          })
        ];

        define_submap = [
          (mkSubmap {
            name = session;
            escape = true;
            bind = [
              (mkSubmapBind {
                key = combos.plain "L";
                dispatcher = dsp.exec_cmd {
                  cmd = lock;
                };

                flags = {
                  description = mkDesc "session lock";
                };
              })

              (mkSubmapBind {
                key = combos.plain "E";
                dispatcher = dsp.exec_cmd {
                  cmd = logout;
                };

                flags = {
                  description = mkDesc "session logout";
                };
              })

              (mkSubmapBind {
                key = combos.plain "P";
                dispatcher = dsp.exec_cmd {
                  cmd = poweroff;
                };

                flags = {
                  description = mkDesc "poweroff";
                };
              })

              (mkSubmapBind {
                key = combos.plain "R";
                dispatcher = dsp.exec_cmd {
                  cmd = reboot;
                };

                flags = {
                  description = mkDesc "reboot";
                };
              })

              (mkSubmapBind {
                key = combos.plain "S";
                dispatcher = dsp.exec_cmd {
                  cmd = suspend;
                };

                flags = {
                  description = mkDesc "suspend";
                };
              })
            ];
          })
        ];
      };
    };
  };
}
