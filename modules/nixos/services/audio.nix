{ config, lib, ... }:

let
  cfg = config.nixosServicesModules.audio;
  masterEnable = config.nixosServicesModules.enable;
in
{
  options.nixosServicesModules.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable audio services";
      default = true;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "pulseaudio"
        "pipewire"
      ];
      description = "audio server";
      default = "pipewire";
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    security = {
      rtkit = lib.mkIf (cfg.use == "pipewire") {
        enable = true;
      };
    };

    services = {
      pulseaudio = lib.mkIf (cfg.use == "pulseaudio") {
        enable = true;
      };

      pipewire = lib.mkIf (cfg.use == "pipewire") {
        enable = true;
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
    };
  };
}
