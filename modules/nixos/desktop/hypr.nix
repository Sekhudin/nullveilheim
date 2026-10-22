{
  config,
  ...
}:

let
  cfg = config.nixosDesktop;
in
{
  programs.hyprland = {
    enable = cfg.enable;
    withUWSM = true;
    xwayland = {
      enable = true;
    };
    systemd = {
      setPath = {
        enable = true;
      };
    };
  };
}
