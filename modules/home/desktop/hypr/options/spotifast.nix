{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.spotifast;
in
{
  options.programs.spotifast = {
    enable = lib.mkEnableOption "spotifast";

    package = lib.mkPackageOption pkgs "spotifast" {
      nullable = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    wayland.windowManager.hyprland = {
      settings.window_rule = [
      ];
    };
  };
}
