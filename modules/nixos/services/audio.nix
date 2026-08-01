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

    rtkit = lib.mkOption {
      type = lib.types.attrs;
      description = "rtkit settings";
      default = { };
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
    security = {
      rtkit = lib.mkMerge [
        {
          enable = true;
        }
        cfg.rtkit
      ];
    };

    services = {
      pulseaudio = lib.mkMerge [
        {
          enable = cfg.use == "pulseaudio";
        }
        cfg.pulseaudio
      ];

      pipewire = lib.mkMerge [
        (lib.mkIf (cfg.use == "pipewire") {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };

          pulse = {
            enable = true;
          };
        })
        cfg.pipewire
      ];
    };
  };
}
