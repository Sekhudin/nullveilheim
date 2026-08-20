{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland)
    mkBind
    getVar
    dsp
    combos
    ;

  keys = {
    brightness_down = "XF86MonBrightnessDown";
    brightness_up = "XF86MonBrightnessUp";

    media_next = "XF86AudioNext";
    media_prev = "XF86AudioPrev";
    media_playback = "XF86AudioPlay";

    mic_mute = "XF86AudioMicMute";

    volume_down = "XF86AudioLowerVolume";
    volume_up = "XF86AudioRaiseVolume";
    volume_mute = "XF86AudioMute";

    capslock = "Caps_Lock";
    numlock = "Num_Lock";
  };

  actions = {
    brightness_down = getVar "actions.brightness_down";
    brightness_up = getVar "actions.brightness_up";

    media_next = getVar "actions.media_next";
    media_prev = getVar "actions.media_prev";
    media_playback = getVar "actions.media_playback";

    mic_mute = getVar "actions.mic_mute";

    volume_down = getVar "actions.volume_down";
    volume_up = getVar "actions.volume_up";
    volume_mute = getVar "actions.volume_mute";

    capslock = getVar "actions.capslock";
    numlock = getVar "actions.numlock";
  };
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.plain keys.brightness_down;
            dispatcher = dsp.exec_cmd {
              cmd = actions.brightness_down;
            };
            flags = {
              repeating = true;
              description = "brightness down";
            };
          })

          (mkBind {
            key = combos.plain keys.brightness_up;
            dispatcher = dsp.exec_cmd {
              cmd = actions.brightness_up;
            };
            flags = {
              repeating = true;
              description = "brightness up";
            };
          })

          (mkBind {
            key = combos.plain keys.media_next;
            dispatcher = dsp.exec_cmd {
              cmd = actions.media_next;
            };
            flags = {
              repeating = true;
              description = "media next";
            };
          })

          (mkBind {
            key = combos.plain keys.media_prev;
            dispatcher = dsp.exec_cmd {
              cmd = actions.media_prev;
            };
            flags = {
              repeating = true;
              description = "media prev";
            };
          })

          (mkBind {
            key = combos.plain keys.media_playback;
            dispatcher = dsp.exec_cmd {
              cmd = actions.media_playback;
            };
            flags = {
              repeating = true;
              description = "media playback";
            };
          })

          (mkBind {
            key = combos.plain keys.mic_mute;
            dispatcher = dsp.exec_cmd {
              cmd = actions.mic_mute;
            };
            flags = {
              repeating = true;
              description = "volume input mute";
            };
          })

          (mkBind {
            key = combos.plain keys.volume_down;
            dispatcher = dsp.exec_cmd {
              cmd = actions.volume_down;
            };
            flags = {
              repeating = true;
              description = "volume output down";
            };
          })

          (mkBind {
            key = combos.plain keys.volume_up;
            dispatcher = dsp.exec_cmd {
              cmd = actions.volume_up;
            };
            flags = {
              repeating = true;
              description = "volume output up";
            };
          })

          (mkBind {
            key = combos.plain keys.volume_mute;
            dispatcher = dsp.exec_cmd {
              cmd = actions.volume_mute;
            };
            flags = {
              repeating = true;
              description = "volume output mute";
            };
          })

          (mkBind {
            key = combos.plain keys.capslock;
            dispatcher = dsp.exec_cmd {
              cmd = actions.capslock;
            };
            flags = {
              description = "capslock";
            };
          })

          (mkBind {
            key = combos.plain keys.numlock;
            dispatcher = dsp.exec_cmd {
              cmd = actions.numlock;
            };
            flags = {
              description = "numlock";
            };
          })
        ];
      };
    };
  };
}
