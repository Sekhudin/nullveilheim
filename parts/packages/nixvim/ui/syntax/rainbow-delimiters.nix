{ config, ... }:

let
  cfg = config.nixvimUI;
  enableRainbow-delimiters = cfg.syntax == "rainbow-delimiters";
in
{
  plugins.rainbow-delimiters = {
    enable = enableRainbow-delimiters;
    settings = { };
  };
}
