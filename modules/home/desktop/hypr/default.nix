{
  inputs,
  pkgs,
  config,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktop;
  inherit (extraLib) mkImports;

  packages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = mkImports {
    recursive = true;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  wayland = {
    systemd = {
      target = if cfg.enable then "hyprland-session.target" else "graphical-session.target";
    };
  };

  wayland.windowManager.hyprland = {
    enable = cfg.enable;
    package = packages.hyprland;
    configType = "lua";
    systemd = {
      enable = true;
    };
    plugins = [ ];
  };
}
