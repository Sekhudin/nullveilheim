{
  inputs,
  pkgs,
  config,
  lib,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;

  toml = pkgs.formats.toml { };

  mkHotkey = key: "<Control><Shift>${key}";
  hotkeys = {
    keystroke = mkHotkey "k";
    bubble = mkHotkey "b";
    pause = mkHotkey "p";
    focus = mkHotkey "f";
  };
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        inputs.hibiki.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

    xdg.configFile = {
      "hibiki/config.toml" = {
        force = true;
        source = toml.generate "config.toml" rec {
          display_mode = "keystroke";
          position = "bottomcenter";
          display_timeout_ms = 1000;
          max_keys = 5;
          margin = 20;
          show_modifiers = true;
          all_keyboards = false;
          font_scale = 1.0;
          opacity = 0.9;
          font_family = font.family.monospace;
          font_size = 1.0;
          keystroke_theme = "dark";
          keystroke_draggable = false;
          keystroke_hotkey = hotkeys.keystroke;
          pause_hotkey = hotkeys.pause;
          toggle_focus_hotkey = hotkeys.focus;
          auto_detect_layout = true;
          corner_radius = 0.2;
          audio = {
            enabled = true;
            volume = 0.8;
            sound_pack = "cherrymx-blue-abs";
          };
          bubble = {
            font_family = font_family;
            font_size = font_size;
            color = "#3584e4";
            position = "topright";
            draggable = false;
            hotkey = hotkeys.bubble;
            timeout_ms = display_timeout_ms;
            opacity = opacity;
            corner_radius = corner_radius;
            audio = audio;
          };
        };
      };
    };
  };
}
