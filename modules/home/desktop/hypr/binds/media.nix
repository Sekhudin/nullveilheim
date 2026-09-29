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

  media = hypr.getVarRefs config "media";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.media_next;
          dispatcher = hl.dsp.exec_cmd {
            cmd = media.next;
          };
          flags = {
            repeating = true;
            description = "play next track";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.media_prev;
          dispatcher = hl.dsp.exec_cmd {
            cmd = media.prev;
          };
          flags = {
            repeating = true;
            description = "play previous track";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.media_toggle;
          dispatcher = hl.dsp.exec_cmd {
            cmd = media.toggle;
          };
          flags = {
            repeating = true;
            description = "toggle media playback";
          };
        })
      ];
    };
  };
}
