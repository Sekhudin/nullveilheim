{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.herdr;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.herdr = {
    enable = lib.mkEnableOption "herdr terminal multiplexer";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.herdr;
      description = "Package to use for Herdr.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Herdr TOML configuration settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."herdr/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "herdr-config.toml" cfg.settings;
    };
  };
}
