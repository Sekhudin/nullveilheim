{ config, lib, ... }:

let
  cfg = config.nixosServicesModules.audio;
  masterEnable = config.nixosServicesModules.enable;
in
{
  options.nixosServicesModules.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "activate audio services";
      default = true;
    };

    pulseaudio = lib.mkOption {
      type = lib.types.attrs;
      description = "pulseaudio settings";
      default = { };
    };

    pipewire = lib.mkOption {
      type = lib.types.attrs;
      description = "pipewire settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    services.rtkit.enable = true;
    services.pulseaudio = lib.mkMerge [
      {
        enable = true;
      }
      cfg.pulseaudio
    ];

    services.pipewire = lib.mkMerge [
      {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse = {
          enable = true;
        };
      }
      cfg.pipewire
    ];
  };
}
