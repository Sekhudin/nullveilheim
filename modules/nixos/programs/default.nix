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
  imports = [ ];

  options.nixosProgramsModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable programs modules";
      default = true;
    };
  };

  config = {
    environment = lib.mkIf cfg.enable {
      systemPackages = with pkgs; [
        curl
        wget
        git
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
      ];
    };
  };
}
