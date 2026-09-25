{
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.dbeaver;
  core = config.homeCore;
in
{
  options.homeApps.dbeaver = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable dbeaver";
      default = true;
    };
  };

  config = {
    programs.dbeaver = {
      enable = cfg.enable;
      dataSourcesSettings = {
        connections = { };
        folders = { };
      };
      settings = { };
    };

    xdg.desktopEntries = lib.mkIf (cfg.enable && core.opengl != "") {
      dbeaver = {
        name = "DBeaver";
        type = "Application";
        icon = "dbeaver";
        exec = "${core.opengl} dbeaver";
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
