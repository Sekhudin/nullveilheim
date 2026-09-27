{
  lib,
  luaLib,
  mkVar,
  getVarRefs,
  ...
}:

let
  mkComboKey =
    modifiers: key:
    let
      modifiers' = map luaLib.toLua modifiers;
      key' = if key == null then null else luaLib.toLua key;
      prefix = lib.concatStringsSep ''.. " + " .. '' modifiers';
    in
    if lib.length modifiers' == 0 then
      key'
    else if key' == null then
      prefix
    else
      ''${prefix} .. " + " .. ${key'}'';

  dummy.wayland.windowManager.hyprland.settings = {
    mouse = mkVar {
      left = "mouse:272";
      right = "mouse:273";
      middle = "mouse:274";
      back = "mouse:275";
      forward = "mouse:276";
    };

    keys = mkVar {
      mod = "SUPER";
      alt = "ALT";
      ctrl = "CTRL";
      shift = "SHIFT";

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

      print = "Print";
    };
  };

  mouse = getVarRefs dummy "mouse";
  keys = getVarRefs dummy "keys";
in
{
  variables = {
    inherit (dummy.wayland.windowManager.hyprland.settings)
      mouse
      keys
      ;
  };

  ctl = {
    combos = {
      plain = mkComboKey [ ];
      of = mkComboKey;
      mod = mkComboKey [ keys.mod ];
      alt = mkComboKey [ keys.alt ];
      ctrl = mkComboKey [ keys.ctrl ];
      shift = mkComboKey [ keys.shift ];
    };

    directions = {
      left = "l";
      right = "r";
      up = "u";
      down = "d";
    };

    inherit
      keys
      mouse
      ;
  };
}
