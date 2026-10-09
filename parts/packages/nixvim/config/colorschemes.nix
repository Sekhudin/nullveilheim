{ config, lib, ... }:

let
  cfg = config.nixvimConfig;
in
{

  options.nixvimConfig = {
    colorscheme = lib.mkOption {
      type = lib.types.enum [
        "base16"
        "kanagawa"
        "tokyonight"
      ];
      description = "choose scheme";
      default = "base16";
    };
  };

  config = {
    colorschemes = {
      base16 = {
        enable = (cfg.colorscheme == "base16");
        autoLoad = true;
        colorscheme = null;
      };

      kanagawa = {
        enable = (cfg.colorscheme == "kanagawa");
        settings = {
          theme = "dragon";
          transparent = false;
          undercurl = false;
          commentStyle = {
            italic = true;
          };
          colors = {
            palette = { };
            theme = {
              wave = { };
              lotus = { };
              dragon = { };
              all = { };
            };
          };
        };
      };

      tokyonight = {
        enable = (cfg.colorscheme == "tokyonight");
        settings = {
          style = "night";
          transparent = false;
        };
      };
    };
  };
}
