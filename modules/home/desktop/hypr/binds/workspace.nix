{
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

  mkWorkspaceBind =
    {
      count,
      extraBind ? [ ],
    }:
    (lib.flatten (
      lib.genList (
        i:
        let
          workspace = i + 1;
          key = toString workspace;
        in
        [
          (hypr.mkBind {
            key = ctl.combos.mod key;
            dispatcher = hl.dsp.focus {
              inherit workspace;
            };
            flags = {
              description = "switch to workspace ${toString workspace}";
            };
          })

          (hypr.mkBind {
            key = ctl.combos.of [
              ctl.keys.mod
              ctl.keys.shift
            ] key;
            dispatcher = hl.dsp.window.move {
              inherit workspace;
            };
            flags = {
              description = "move window to workspace ${toString workspace}";
            };
          })
        ]
      ) count
    ))
    ++ extraBind;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = mkWorkspaceBind {
        count = 9;
        extraBind = [ ];
      };
    };
  };
}
