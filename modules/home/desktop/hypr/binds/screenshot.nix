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
  menus = hypr.getVarRefs config "menus";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.shift ctl.keys.print;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.screenshot_fullscreen;
          };
          flags = {
            description = "screenshot fullscreen";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.print;
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.screenshot;
          };
          flags = {
            description = "show screenshot menu";
          };
        })
      ];
    };
  };
}
