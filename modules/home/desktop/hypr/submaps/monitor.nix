{
  config,
  lib,
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

  mkDesc = desc: "(M) ${desc}";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.alt "M";
          dispatcher = hl.dsp.submap {
            name = submaps.monitor;
          };
          flags = {
            description = mkDesc "enter monitor submap";
          };
        })
      ];

      define_submap = [
        (hypr.mkSubmap {
          name = submaps.monitor;
          escape = true;
          bind = [
            # focus monitor
            (hypr.mkSubmapBind {
              key = ctl.combos.plain "H";
              dispatcher = hl.dsp.focus {
                monitor = "-1";
              };
              flags = {
                description = mkDesc "move focus to previous monitor";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "L";
              dispatcher = hl.dsp.focus {
                monitor = "+1";
              };
              flags = {
                description = mkDesc "move focus to next monitor";
              };
            })

            # move window
            (hypr.mkSubmapBind {
              key = ctl.combos.shift "H";
              dispatcher = hl.dsp.window.move {
                monitor = "-1";
              };
              flags = {
                description = mkDesc "move window to previous monitor";
              };
            })
            (hypr.mkSubmapBind {
              key = ctl.combos.shift "L";
              dispatcher = hl.dsp.window.move {
                monitor = "+1";
              };
              flags = {
                description = mkDesc "move window to next monitor";
              };
            })

            # move workspace
            (hypr.mkSubmapBind {
              key = ctl.combos.ctrl "H";
              dispatcher = hl.dsp.workspace.move {
                monitor = "-1";
              };
              flags = {
                description = mkDesc "move workspace to previous monitor";
              };
            })
            (hypr.mkSubmapBind {
              key = ctl.combos.ctrl "L";
              dispatcher = hl.dsp.workspace.move {
                monitor = "+1";
              };
              flags = {
                description = mkDesc "move workspace to next monitor";
              };
            })
          ];
        })
      ];
    };
  };
}
