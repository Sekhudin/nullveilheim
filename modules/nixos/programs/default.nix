{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.nixosProgramsModules;
in
{
  imports = [
    ./steam.nix
  ];

  options.nixosProgramsModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable programs modules";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 1";
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
        wireplumber
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
