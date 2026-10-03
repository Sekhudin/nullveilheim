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

  mic = hypr.getVarRefs config "mic";
  bindGroup = "mic";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.ctrl ctl.keys.volume_down;
          dispatcher = hl.dsp.exec_cmd {
            cmd = mic.down;
          };
          flags = {
            repeating = true;
            description = "decrease system volume";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.ctrl ctl.keys.volume_up;
          dispatcher = hl.dsp.exec_cmd {
            cmd = mic.up;
          };
          flags = {
            repeating = true;
            description = "increase system volume";
          };
        })

        (hypr.mkBind {
          group = bindGroup;
          key = ctl.combos.plain ctl.keys.mic_toggle;
          dispatcher = hl.dsp.exec_cmd {
            cmd = mic.toggle;
          };
          flags = {
            repeating = true;
            description = "toggle microphone toggle";
          };
        })
      ];
    };
  };
}
