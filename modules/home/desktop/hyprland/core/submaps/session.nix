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

  submaps = {
    session = getVar "submaps.session";
  };

  actions = {
    lock = getVar "actions.lock";
    logout = getVar "actions.logout";
    poweroff = getVar "actions.poweroff";
    reboot = getVar "actions.reboot";
    suspend = getVar "actions.suspend";
  };

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
              name = submaps.session;
            };
            flags = {
              description = mkDesc "enter submap session";
            };
          })
        ];

        define_submap = [
          (mkSubmap {
            name = submaps.session;
            escape = true;
            bind = [
              (mkSubmapBind {
                key = combos.plain "L";
                dispatcher = dsp.exec_cmd {
                  cmd = actions.lock;
                };

                flags = {
                  description = mkDesc "session lock";
                };
              })

              (mkSubmapBind {
                key = combos.plain "E";
                dispatcher = dsp.exec_cmd {
                  cmd = actions.logout;
                };

                flags = {
                  description = mkDesc "session logout";
                };
              })

              (mkSubmapBind {
                key = combos.plain "P";
                dispatcher = dsp.exec_cmd {
                  cmd = actions.poweroff;
                };

                flags = {
                  description = mkDesc "poweroff";
                };
              })

              (mkSubmapBind {
                key = combos.plain "R";
                dispatcher = dsp.exec_cmd {
                  cmd = actions.reboot;
                };

                flags = {
                  description = mkDesc "reboot";
                };
              })

              (mkSubmapBind {
                key = combos.plain "S";
                dispatcher = dsp.exec_cmd {
                  cmd = actions.suspend;
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
