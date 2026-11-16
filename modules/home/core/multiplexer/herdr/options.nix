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

    skipConfigFile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to skip creating the Herdr configuration file.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Herdr TOML configuration settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.wl-clipboard
      pkgs.xsel
    ];

    xdg.configFile."herdr/config.toml" = lib.mkIf (!cfg.skipConfigFile) {
      source = tomlFormat.generate "herdr-config.toml" cfg.settings;
    };
  };
}
