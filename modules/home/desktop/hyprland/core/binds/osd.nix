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

    mic_down = null;
    mic_up = null;
    mic_mute = "XF86AudioMicMute";

    volume_down = "XF86AudioLowerVolume";
    volume_up = "XF86AudioRaiseVolume";
    volume_mute = "XF86AudioMute";

    capslock = "Caps_Lock";
    numlock = "Num_Lock";
  };

  actions = {
    brightness_down = getVar "actions.brightness-down";
    brightness_up = getVar "actions.brightness-up";

    media_next = getVar "actions.media-next";
    media_prev = getVar "actions.media-prev";
    media_playback = getVar "actions.media-playback";

    mic_down = getVar "actions.mic-down";
    mic_up = getVar "actions.mic-up";
    mic_mute = getVar "actions.mic-mute";

    volume_down = getVar "actions.volume-down";
    volume_up = getVar "actions.volume-up";
    volume_mute = getVar "actions.volume-mute";

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
              description = "brightness down";
            };
          })
          (mkBind {
            key = combos.plain keys.brightness_down;
            dispatcher = dsp.exec_cmd {
              cmd = actions.brightness_up;
            };
            flags = {
              description = "brightness down";
            };
          })
        ];
      };
    };
  };
}
