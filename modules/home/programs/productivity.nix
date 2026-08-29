{
  config,
  pkgs,
  lib,
  color,
  icon,
  ...
}:

let
  cfg = config.homeProgramsModules.productivity;
  master = config.homeProgramsModules;
  openGL = config.homeCoreModules.openGL;
  masterEnable = master.enable;
  openGLEnable = (openGL.use != "default");
  inherit (color) mkTokens;

  mkLuaInline = lib.generators.mkLuaInline;

  tokens = mkTokens config.homeCoreModules.theme;
in
{
  options.homeProgramsModules.productivity = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable productivity";
      default = true;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home = {
      packages = with pkgs; [
        telegram-desktop
        slack
        wpsoffice

        #ai
        opencode
        gemini-cli
        claude-code
      ];
    };

    programs = {
      discord = {
        enable = true;
      };

      dbeaver = {
        enable = true;
        dataSourcesSettings = {
          connections = { };
          folders = { };
        };
        settings = { };
      };

      firefox = {
        enable = true;
      };

      yazi = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
        enableZshIntegration = config.programs.zsh.enable;
        extraPackages = with pkgs; [
          exiftool
        ];
        theme = {
          app = {
            overall = {
              bg = tokens.bg;
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
                fg = tokens.fg;
                bg = tokens.bg;
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

    xdg.desktopEntries = lib.mkIf openGLEnable {
      "org.telegram.desktop" = {
        name = "Telegram";
        type = "Application";
        icon = "org.telegram.desktop";
        exec = "${openGL.use} telegram-desktop %u";
        comment = "New era of messaging";
        terminal = false;
        actions.quit.name = "Quit Telegram";
        actions.quit.exec = "${openGL.use} telegram-desktop -quit";
        actions.quit.icon = "application-exit";
        settings.SingleMainWindow = "true";
        settings.StartupWMClass = "TelegramDesktop";
        settings.X-GNOME-UsesNotifications = "true";
        settings.X-GNOME-SingleWindow = "true";
        settings.Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop;";
        mimeType = [
          "x-scheme-handler/tg"
          "x-scheme-handler/tonsite"
        ];
        categories = [
          "Chat"
          "Network"
          "InstantMessaging"
          "Qt"
        ];
      };

      slack = {
        name = "Slack";
        type = "Application";
        icon = "slack";
        exec = "${openGL.use} slack --no-sandbox -s %u";
        comment = "Slack Desktop";
        mimeType = [ "x-scheme-handler/slack" ];
        settings.StartupWMClass = "Slack";
        categories = [
          "GNOME"
          "GTK"
          "Network"
          "InstantMessaging"
        ];
      };

      discord = {
        name = "Discord";
        type = "Application";
        icon = "discord";
        exec = "${openGL.use} discord --no-sandbox";
        comment = "All-in-one cross-platform voice and text chat for gamers";
        mimeType = [ "x-scheme-handler/discord" ];
        settings.StartupWMClass = "discord";
        categories = [
          "Network"
          "InstantMessaging"
        ];
      };

      dbeaver = {
        name = "DBeaver";
        type = "Application";
        icon = "dbeaver";
        exec = "${openGL.use} dbeaver";
        comment = "Universal Database Manager and SQL Client";
        terminal = false;
        settings.StartupWMClass = "DBeaver";
        settings.Keywords = "Database;SQL;IDE;JDBC;ODBC;MySQL;PostgreSQL;Oracle;DB2;MariaDB;";
        settings.StartupNotify = "true";
        mimeType = [
          "application/sql"
        ];
        categories = [
          "IDE"
          "Development"
        ];
      };
    };
  };
}
