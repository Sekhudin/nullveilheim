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
    ./zsh.nix
  ];

  options.nixosProgramsModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable programs modules";
      default = false;
    };
  };

  config = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 1";
      };
    };

    environment = lib.mkIf cfg.enable {
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
        neovim
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
