{
  config,
  pkgs,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.nixosProgramsModules;
  inherit (extraLib) mkImports;
in
{
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  options.nixosProgramsModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable programs modules";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 1";
        };
      };

      fish = {
        enable = true;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        nh
        git
        curl
        wget
        fastfetch
        pciutils
        usbutils
        coreutils
        unzip
        zip
        p7zip
        ntfs3g
        dnsutils
        brightnessctl
        pavucontrol
        # neovim
        btop
        ripgrep
        fd
        xsel
        (writeScriptBin "copy" "xsel -ib")
        (writeScriptBin "paste" "xsel -ob")
      ];
    };
  };
}
