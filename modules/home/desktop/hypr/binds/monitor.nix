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

  submaps = hypr.getVarRefs config "submaps";
  bindGroup = "submap - monitor";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.alt "M";
          dispatcher = hl.dsp.submap {
            name = submaps.monitor;
          };
          flags = {
            description = "enter monitor submap";
          };
        })
      ];

      define_submap = [
        (hypr.mkSubmap {
          group = bindGroup;
          name = submaps.monitor;
          escape = true;
          bind = [
            # focus monitor
            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.plain "H";
              dispatcher = hl.dsp.focus {
                monitor = "-1";
              };
              flags = {
                description = "focus previous monitor";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.plain "L";
              dispatcher = hl.dsp.focus {
                monitor = "+1";
              };
              flags = {
                description = "focus next monitor";
              };
            })

            # move window
            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.shift "H";
              dispatcher = hl.dsp.window.move {
                monitor = "-1";
              };
              flags = {
                description = "move window to previous monitor";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.shift "L";
              dispatcher = hl.dsp.window.move {
                monitor = "+1";
              };
              flags = {
                description = "move window to next monitor";
              };
            })

            # move workspace
            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.ctrl "H";
              dispatcher = hl.dsp.workspace.move {
                monitor = "-1";
              };
              flags = {
                description = "move workspace to previous monitor";
              };
            })

            (hypr.mkSubmapBind {
              group = bindGroup;
              key = ctl.combos.ctrl "L";
              dispatcher = hl.dsp.workspace.move {
                monitor = "+1";
              };
              flags = {
                description = "move workspace to next monitor";
              };
            })
          ];
        })
      ];
    };
  };
}
