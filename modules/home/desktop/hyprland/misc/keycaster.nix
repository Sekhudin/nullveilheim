{
  inputs,
  pkgs,
  config,
  lib,
  extraLib,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) getVarRef;

  toml = pkgs.formats.toml { };

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";

  mkHotkey = key: "<Control><Shift>${key}";
  hotkeys = {
    keystroke = mkHotkey "k";
    bubble = mkHotkey "b";
    pause = mkHotkey "p";
    focus = mkHotkey "f";
  };

  yakc = pkgs.appimageTools.wrapType2 {
    pname = "yakc";
    version = "2.8.1";
    src = pkgs.fetchurl {
      url = "https://github.com/iammodev/YAKC/releases/download/v2.8.1/YAKC_2.8.1_amd64.AppImage";
      hash = "sha256-vbCkEzoJDBFA4aewOco3PGj3Oz5PZD1kct9U8m4TQ8c=";
    };

    extraPkgs =
      pkgs: with pkgs; [
        wayland
        libxkbcommon
        mesa
        libglvnd
        webkitgtk_4_1
        gtk3
        glib
        pango
        cairo
        gdk-pixbuf
      ];

    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];

    extraInstallCommands = ''
      wrapProgram $out/bin/yakc \
        --set LD_PRELOAD "${pkgs.wayland}/lib/libwayland-client.so"
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        inputs.hibiki.packages.${pkgs.stdenv.hostPlatform.system}.default
        yakc
      ];
    };

    xdg.configFile = {
      "hibiki/config.toml" = {
        force = true;
        source = toml.generate "config.toml" rec {
          display_mode = "keystroke";
          position = "bottomcenter";
          display_timeout_ms = 2000;
          max_keys = 1;
          margin = 10;
          show_modifiers = true;
          all_keyboards = false;
          font_scale = 1.0;
          opacity = styles.opacity;
          font_family = font.family.monospace;
          font_size = 1.0;
          font_color = tokens.fg;
          color = tokens.bg;
          keystroke_theme = "dark";
          keystroke_draggable = false;
          keystroke_hotkey = hotkeys.keystroke;
          pause_hotkey = hotkeys.pause;
          toggle_focus_hotkey = hotkeys.focus;
          auto_detect_layout = false;
          corner_radius = 0.4;
          audio = {
            enabled = false;
            volume = 0.8;
            sound_pack = "cherrymx-blue-abs";
          };
          bubble = {
            font_family = font_family;
            font_size = font_size;
            font_color = font_color;
            color = color;
            position = "topleft";
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
