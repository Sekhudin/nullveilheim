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

  ipc = hypr.getVarRefs config "ipc";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.mod ctl.keys.slash;
          dispatcher = hl.dsp.exec_cmd {
            cmd = ipc.help;
          };
          flags = {
            description = "keybind reference and help";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] ctl.keys.slash;
          dispatcher = hl.dsp.exec_cmd {
            cmd = ipc.keyviz;
          };
          flags = {
            description = "keyviz toggle";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.mod "D";
          dispatcher = hl.dsp.exec_cmd {
            cmd = ipc.dock;
          };
          flags = {
            description = "dock toggle";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.of [
            ctl.keys.mod
            ctl.keys.shift
          ] "D";
          dispatcher = hl.dsp.exec_cmd {
            cmd = ipc.bar;
          };
          flags = {
            description = "bar toggle";
          };
        })
      ];
    };
  };
}
