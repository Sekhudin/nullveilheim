{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeProgramsModules.productivity;
  master = config.homeProgramsModules;
  openGL = config.homeCoreModules.openGL;
  masterEnable = master.enable;
  openGLEnable = (openGL.use != "default");
in
{
  options.homeProgramsModules.productivity = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable productivity";
      default = true;
    };

    discord = lib.mkOption {
      type = lib.types.attrs;
      description = "discord settings";
      default = { };
    };

    dbeaver = lib.mkOption {
      type = lib.types.attrs;
      description = "dbeaver settings";
      default = { };
    };

    firefox = lib.mkOption {
      type = lib.types.attrs;
      description = "firefox settings";
      default = { };
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
      discord = lib.mkMerge [
        {
          enable = true;
        }
        cfg.discord
      ];

      dbeaver = lib.mkMerge [
        {
          enable = true;
          dataSourcesSettings = {
            connections = { };
            folders = { };
          };
          settings = { };
        }
        cfg.dbeaver
      ];

      firefox = lib.mkMerge [
        {
          enable = true;
        }
        cfg.firefox
      ];
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
        exec = "${openGL.use} ${pkgs.slack}/bin/slack --no-sandbox -s %u";
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
