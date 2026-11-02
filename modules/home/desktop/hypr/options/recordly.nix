{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.recordly;
in
{
  options.programs.recordly = {
    enable = lib.mkEnableOption "recordly";

    package = lib.mkPackageOption pkgs "recordly" {
      nullable = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.optionals (cfg.package != null) [
      cfg.package
    ];
  };
}
