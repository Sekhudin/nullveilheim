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
          key = ctl.combos.plain "XF86PowerOff";
          dispatcher = hl.dsp.exec_cmd {
            cmd = menus.power;
          };
          flags = {
            description = "powermenu applet";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "escape";
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.lock;
          };
          flags = {
            description = "lock screen";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "E";
          dispatcher = hl.dsp.exit { };
          flags = {
            description = "logout session";
          };
        })
      ];
    };
  };
}
