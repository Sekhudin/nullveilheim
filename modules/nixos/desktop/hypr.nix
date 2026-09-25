{
  inputs,
  pkgs,
  config,
  ...
}:

let
  cfg = config.nixosDesktop;
  packages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.hyprland = {
    enable = cfg.enable;
    package = packages.hyprland;
    portalPackage = packages.xdg-desktop-portal-hyprland;
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
