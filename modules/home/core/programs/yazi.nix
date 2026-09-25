{
  pkgs,
  config,
  lib,
  icon,
  ...
}:

let
  core = config.homeCore;
  cfg = core.programs.yazi;
  theme = core.themeConfig;
  mkLuaInline = lib.generators.mkLuaInline;
in
{
  options.homeCore.programs.yazi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable yazi";
      default = true;
    };
  };

  config = {
    programs.yazi = {
      enable = cfg.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      extraPackages = with pkgs; [
        exiftool
      ];
      theme = {
        app = {
          overall = {
            bg = theme.tokens.bg;
          };
        };
        indicator = {
          padding = {
            open = icon.block_open;
            close = icon.block_close;
          };
        };
      };
      settings = {
        mgr = {
          mouse_events = [ ];
        };
      };
      plugins = {
        chmod = {
          package = pkgs.yaziPlugins.chmod;
        };
        full-border = {
          package = pkgs.yaziPlugins.full-border;
          setup = true;
          settings = {
            type = mkLuaInline "ui.Border.PLAIN";
          };
        };
        jump-to-char = {
          package = pkgs.yaziPlugins.jump-to-char;
        };
        mount = {
          package = pkgs.yaziPlugins.mount;
        };
        smart-enter = {
          package = pkgs.yaziPlugins.smart-enter;
        };
        yatline = {
          package = pkgs.yaziPlugins.yatline;
          setup = true;
          settings = {
            padding = {
              inner = 1;
              outer = 1;
            };
            display_header_line = false;
            display_status_line = true;
            component_positions = [
              "status"
              "tab"
            ];
            section_separator = {
              open = icon.circle_left;
              close = icon.circle_right;
            };
            part_separator = {
              open = icon.resource;
              close = icon.resource;
            };
            style_c = {
              fg = theme.tokens.fg;
              bg = theme.tokens.bg;
            };
          };
        };
      };
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = [ "?" ];
              run = "help";
              desc = "Open help";
            }
            {
              on = [
                "q"
              ];
              run = "noop";
            }
            {
              on = [
                "~"
              ];
              run = "noop";
            }
            {
              on = [
                ":"
                "q"
              ];
              run = "quit";
              desc = "Quit";
            }
            {
              on = [ "o" ];
              run = "plugin smart-enter";
              desc = "Enter directory, or open the file";
            }
            {
              on = [ "<Enter>" ];
              run = "plugin smart-enter";
              desc = "Enter directory, or open the file";
            }
            {
              on = [
                "c"
                "m"
              ];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }
            {
              on = [
                "g"
                "m"
              ];
              run = "plugin mount";
              desc = "Go to mount media";
            }
            {
              on = [ "f" ];
              run = "plugin jump-to-char";
              desc = "Jump to char";
            }
          ];
        };
      };
    };
  };
}
