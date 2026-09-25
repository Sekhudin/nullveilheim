{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.telegram-desktop;
  core = config.homeCore;
in
{
  options.homeApps.telegram-desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable telegram-desktop";
      default = true;
    };
  };

  config = {
    home = lib.mkIf cfg.enable {
      packages = with pkgs; [
        telegram-desktop
      ];
    };

    xdg.desktopEntries = lib.mkIf (cfg.enable && core.opengl != "") {
      "org.telegram.desktop" = {
        name = "Telegram";
        type = "Application";
        icon = "org.telegram.desktop";
        exec = "${core.opengl} telegram-desktop %u";
        comment = "New era of messaging";
        terminal = false;
        actions.quit.name = "Quit Telegram";
        actions.quit.exec = "${core.opengl} telegram-desktop -quit";
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
    };
  };
}
