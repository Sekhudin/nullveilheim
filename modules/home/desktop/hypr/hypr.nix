{
  inputs,
  pkgs,
  config,
  ...
}:

let
  cfg = config.homeDesktop;
  packages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  wayland.systemd = {
    target = if cfg.enable then "hyprland-session.target" else "graphical-session.target";
  };

  wayland.windowManager.hyprland = {
    enable = cfg.enable;
    package = packages.hyprland;
    configType = "lua";
    systemd.enable = true;
  };
}
