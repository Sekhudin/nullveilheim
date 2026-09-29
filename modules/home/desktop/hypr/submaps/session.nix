{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    ;

  sessions = hypr.getVarRefs config "sessions";
  submaps = hypr.getVarRefs config "submaps";

  mkDesc = desc: "(S) ${desc}";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.alt "S";
          dispatcher = hl.dsp.submap {
            name = submaps.session;
          };
          flags = {
            description = mkDesc "enter session submap";
          };
        })
      ];

      define_submap = [
        (hypr.mkSubmap {
          name = submaps.session;
          escape = true;
          bind = [
            (hypr.mkSubmapBind {
              key = ctl.combos.plain "L";
              dispatcher = hl.dsp.exec_cmd {
                cmd = sessions.lock;
              };

              flags = {
                description = mkDesc "lock current session";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "S";
              dispatcher = hl.dsp.exec_cmd {
                cmd = sessions.lock_suspend;
              };

              flags = {
                description = mkDesc "lock and suspend system";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "E";
              dispatcher = hl.dsp.exec_cmd {
                cmd = sessions.logout;
              };

              flags = {
                description = mkDesc "logout of current session";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "R";
              dispatcher = hl.dsp.exec_cmd {
                cmd = sessions.reboot;
              };

              flags = {
                description = mkDesc "reboot system";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "P";
              dispatcher = hl.dsp.exec_cmd {
                cmd = sessions.shutdown;
              };

              flags = {
                description = mkDesc "shut down system";
              };
            })
          ];
        })
      ];
    };
  };
}
