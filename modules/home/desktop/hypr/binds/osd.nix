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
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.brightness_down;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.brightness_down;
          };
          flags = {
            repeating = true;
            description = "brightness down";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.brightness_up;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.brightness_up;
          };
          flags = {
            repeating = true;
            description = "brightness up";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.media_next;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.media_next;
          };
          flags = {
            repeating = true;
            description = "media next";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.media_prev;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.media_prev;
          };
          flags = {
            repeating = true;
            description = "media prev";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.media_playback;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.media_playback;
          };
          flags = {
            repeating = true;
            description = "media playback";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.mic_mute;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.mic_mute;
          };
          flags = {
            repeating = true;
            description = "volume input mute";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.volume_down;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.volume_down;
          };
          flags = {
            repeating = true;
            description = "volume output down";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.volume_up;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.volume_up;
          };
          flags = {
            repeating = true;
            description = "volume output up";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.volume_mute;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.volume_mute;
          };
          flags = {
            repeating = true;
            description = "volume output mute";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.capslock;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.capslock;
          };
          flags = {
            description = "capslock";
          };
        })

        (hypr.mkBind {
          key = ctl.combos.plain ctl.keys.numlock;
          dispatcher = hl.dsp.exec_cmd {
            cmd = actions.numlock;
          };
          flags = {
            description = "numlock";
          };
        })
      ];
    };
  };
}
