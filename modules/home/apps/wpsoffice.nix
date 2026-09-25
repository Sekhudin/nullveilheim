{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.wpsoffice;
in
{
  options.homeApps.wpsoffice = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable wpsoffice";
      default = true;
    };
  };

  config = {
    home = lib.mkIf cfg.enable {
      packages = with pkgs; [
        wpsoffice
      ];
    };
  };
}
