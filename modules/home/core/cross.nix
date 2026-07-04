{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeCoreModules.cross;
  masterEnable = config.homeCoreModules.enable;
in
{
  options.homeCoreModules.cross = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable cross";
      default = true;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs = {
      direnv = {
        enable = true;
        silent = true;
        nix-direnv = {
          enable = true;
        };
      };

      bat = {
        enable = true;
        config = {
          style = "plain";
          theme = "TwoDark";
        };
      };

      btop = {
        enable = true;
        settings = {
          vim_keys = true;
          show_battery = false;
        };
      };
    };

    home = {
      packages = with pkgs; [
        home-manager
        coreutils
        gnused
        gawk
        curl
        wget
        tree
        ack
        fswatch

        # multi-media
        asciinema
        asciinema-agg
        ffmpeg
        imagemagick

        # productivity
        fzf
        fzy
        dust
        fd
        jq
        iamb
        ripgrep
        docker
        starship
        nixfmt
      ];
    };
  };
}
