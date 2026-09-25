{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.slack;
  core = config.homeCore;
in
{
  options.homeApps.slack = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable slack";
      default = true;
    };
  };

  config = {
    home = lib.mkIf cfg.enable {
      packages = with pkgs; [
        slack
      ];
    };

    xdg.desktopEntries = lib.mkIf (cfg.enable && core.opengl != "") {
      slack = {
        name = "Slack";
        type = "Application";
        icon = "slack";
        exec = "${core.opengl} slack --no-sandbox -s %u";
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
    };
  };
}
