{
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.discord;
  core = config.homeCore;
in
{
  options.homeApps.discord = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable discord";
      default = true;
    };
  };

  config = {
    programs.discord = {
      enable = cfg.enable;
    };

    xdg.desktopEntries = lib.mkIf (cfg.enable && core.opengl != "") {
      discord = {
        name = "Discord";
        type = "Application";
        icon = "discord";
        exec = "${core.opengl} discord --no-sandbox";
        comment = "All-in-one cross-platform voice and text chat for gamers";
        mimeType = [ "x-scheme-handler/discord" ];
        settings.StartupWMClass = "discord";
        categories = [
          "Network"
          "InstantMessaging"
        ];
      };
    };
  };
}
