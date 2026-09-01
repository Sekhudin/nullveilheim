{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland)
    mkEvent
    events
    hl
    ;

  toml = pkgs.formats.toml { };
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        grim
        wayscriber
      ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        on = [
          (mkEvent {
            event = events.config.reloaded;
            action = [
              (hl.exec_cmd {
                cmd = "wayscriber --user enable --now wayscriber.service";
              })
            ];
          })
        ];
      };
    };

    xdg.configFile = {
      "wayscriber/config.toml" = {
        source = toml.generate "config.toml" {
          config_revision = 3;
          keybindings = {
            exit = [ "Escape" ];

            enter_text_mode = [ "t" ];
            enter_sticky_note_mode = [ "n" ];

            undo = [ "u" ];
            redo = [ "Ctrl+R" ];

            copy_selection = [ "y" ];
            paste_selection = [ "p" ];
            delete_selection = [ "x" ];

            nudge_selection_up = [ "k" ];
            nudge_selection_down = [ "j" ];
            nudge_selection_left = [ "h" ];
            nudge_selection_right = [ "l" ];

            nudge_selection_up_large = [ "Ctrl+K" ];
            nudge_selection_down_large = [ "Ctrl+J" ];
            nudge_selection_left_large = [ "Ctrl+H" ];
            nudge_selection_right_large = [ "Ctrl+L" ];

            move_selection_to_start = [ "0" ];
            move_selection_to_end = [ "$" ];

            select_selection_tool = [ "v" ];
            select_pen_tool = [ "f" ];
            select_marker_tool = [ "m" ];
            select_eraser_tool = [ "d" ];

            increase_thickness = [ "=" ];
            decrease_thickness = [ "-" ];

            set_color_red = [ "r" ];
            set_color_green = [ "g" ];
            set_color_blue = [ "b" ];
            set_color_orange = [ "o" ];
            set_color_black = [ "K" ];

            toggle_command_palette = [ ":" ];

            toggle_help = [ "?" ];

            toggle_light_mode = [ "F6" ];

            toggle_frozen_mode = [ "Ctrl+F" ];

            capture_full_screen = [ "Ctrl+Shift+F" ];
            capture_active_window = [ "Ctrl+Shift+W" ];
            capture_selection = [ "Ctrl+Shift+S" ];
          };
        };
      };
    };
  };
}
