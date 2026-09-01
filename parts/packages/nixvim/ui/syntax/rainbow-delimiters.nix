{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimUI;
in
{
  plugins = lib.mkIf (cfg.syntax == "rainbow-delimiters") {
    rainbow-delimiters = {
      enable = true;
      settings = { };
    };
  };
}
