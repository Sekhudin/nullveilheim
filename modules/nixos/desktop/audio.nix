{ config, ... }:

let
  cfg = config.nixosDesktop;
in
{
  services.pipewire = {
    enable = cfg.enable;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse = {
      enable = true;
    };
    jack = {
      enable = true;
    };
    wireplumber = {
      enable = true;
    };
  };

  security = {
    rtkit = {
      enable = cfg.enable;
    };
  };
}
