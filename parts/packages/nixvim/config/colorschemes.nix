{ config, lib, ... }:

let
  cfg = config.nixvimConfig;
in
{

  options.nixvimConfig = {
    colorscheme = lib.mkOption {
      type = lib.types.enum [
        "tokyonight"
        "kanagawa"
      ];
      description = "choose scheme";
      default = "nightfox";
    };
  };

  config = {
    colorschemes = {
      tokyonight = {
        enable = (cfg.colorscheme == "tokyonight");
        settings = {
          style = lib.mkDefault "night";
          transparent = lib.mkDefault false;
        };
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
    };
  };
}
