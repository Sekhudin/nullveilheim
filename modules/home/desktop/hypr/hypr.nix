{
  config,
  ...
}:

let
  cfg = config.homeDesktop;
in
{
  wayland.systemd = {
    target = if cfg.enable then "hyprland-session.target" else "graphical-session.target";
  };

  wayland.windowManager.hyprland = {
    enable = cfg.enable;
    configType = "lua";
    systemd.enable = true;
  };
}
