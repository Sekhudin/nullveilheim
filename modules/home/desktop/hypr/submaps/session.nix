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

  actions = hypr.getVarRefs config "actions";
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
                cmd = actions.lock;
              };

              flags = {
                description = mkDesc "session lock";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "E";
              dispatcher = hl.dsp.exec_cmd {
                cmd = actions.logout;
              };

              flags = {
                description = mkDesc "session logout";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "P";
              dispatcher = hl.dsp.exec_cmd {
                cmd = actions.poweroff;
              };

              flags = {
                description = mkDesc "poweroff";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "R";
              dispatcher = hl.dsp.exec_cmd {
                cmd = actions.reboot;
              };

              flags = {
                description = mkDesc "reboot";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "S";
              dispatcher = hl.dsp.exec_cmd {
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
}
