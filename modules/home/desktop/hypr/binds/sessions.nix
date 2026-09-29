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
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.mod ctl.keys.escape;
          dispatcher = hl.dsp.exec_cmd {
            cmd = sessions.lock;
          };
          flags = {
            description = "lock current session";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "E";
          dispatcher = hl.dsp.exec_cmd {
            cmd = sessions.logout;
          };
          flags = {
            description = "logout of current session";
          };
        })
      ];
    };
  };
}
