{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
in
{
  home = lib.mkIf cfg.enable {
    packages = with pkgs; [
      socat
      coreutils
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
