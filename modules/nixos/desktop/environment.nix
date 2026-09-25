{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nixosDesktop;
in
{
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        brightnessctl
        pavucontrol
      ];
    };
  };
}
