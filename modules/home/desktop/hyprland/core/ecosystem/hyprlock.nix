{
  config,
  lib,
  extraLib,
  color,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  ecosystemEnabled = cfg.ecosystem.use == "default";

  inherit (color) mkRgb mkRgba;
  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  monitors = var "monitors";
  styles = var "styles";
  tokens = var "tokens";
in
{
  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    programs = {
      hyprlock = {
        enable = true;
        extraConfig = "";
        settings = {
          general = {
            hide_cursor = true;
            ignore_empty_input = true;
            text_trim = true;
          };

          auth = {
            pam = {
              enabled = true;
            };
            fingerprint = {
              enabled = true;
              ready_message = "Scan fingerprint to unlock";
              present_message = "Scanning...";
              retry_delay = 250;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "linear, 1, 1, 0, 0"
            ];
            animation = [
              "fadeIn, 1, 5, linear"
              "fadeOut, 1, 5, linear"
              "inputFieldDots, 1, 2, linear"
            ];
          };

          background = {
            monitor = "";
            path = "screenshot";
            color = tokens.bg;
            blur_passes = 2;
            blur_size = 0;
          };

          input-field = {
            monitor = monitors.edp_1;
            size = "18%, 4.5%";
            outline_thickness = 0;
            dots_size = 0.24;
            dots_spacing = 0.20;
            dots_center = false;
            dots_rounding = -1;
            inner_color = mkRgba tokens.fg 0.2;
            font_color = mkRgb tokens.fg;
            font_family = font.family.sans_serif;
            fade_on_empty = true;
            fade_timeout = 2000;
            placeholder_text = "";
            hide_input = false;
            hide_input_base_color = mkRgba tokens.primary 1;
            rounding = styles.rounding;
            check_color = mkRgba tokens.primary 0.5;
            check_text = "Verifying...";
            fail_color = mkRgba tokens.destructive 0.5;
            fail_text = "Incorrect password";
            invert_numlock = false;
            swap_font_color = false;
            position = "0, -92";
            halign = "center";
            valign = "center";
          };

          label = [
            {
              text = "$TIME";
              text_align = "center";
              color = mkRgb tokens.fg;
              font_size = 72;
              font_family = font.family.sans_serif;
              rotate = 0;
              position = "0, 60";
              halign = "center";
              valign = "center";
            }
            {
              text = ''cmd[update:60000] date +"%A, %d %B %Y"'';
              text_align = "center";
              color = mkRgb tokens.fg;
              font_size = 16;
              font_family = font.family.sans_serif;
              rotate = 0;
              position = "0, 0";
              halign = "center";
              valign = "center";
            }
            {
              monitor = monitors.edp_1;
              text = ''<span weight="ultralight">Press any key to unlock</span>'';
              text_align = "center";
              color = mkRgb tokens.fg;
              font_size = 12;
              font_family = font.family.sans_serif;
              rotate = 0;
              position = "0, -140";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };
    };
  };
}
