{ extraLib, ... }:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    ;

in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] ctl.keys.space;
          dispatcher = hl.extra.layout_toggle {
            layouts = [
              "dwindle"
              "master"
              "scrolling"
              "monocle"
            ];
          };
          flags = {
            description = "cycle layout";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "R";
          dispatcher = hl.dsp.exec_cmd {
            cmd = "hyprctl reload config-only";
          };
          flags = {
            description = "reload configuration only";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "R";
          dispatcher = hl.dsp.exec_cmd {
            cmd = "hyprctl reload";
          };
          flags = {
            description = "reload configuration";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "Z";
          dispatcher = hl.extra.zen_mode { };
          flags = {
            description = "toggle zen mode";
          };
        })
      ];
    };
  };
}
