{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  packages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home = lib.mkIf cfg.enable {
    packages = with pkgs; [
      socat
      coreutils
      packages.hyprland
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "k4n4t4/hypr-submap" ];

    widget."k4n4t4/hypr-submap:hypr-submap" = {
      hide_when_default = true;
      glyph = "keyboard";
    };
  };
}
