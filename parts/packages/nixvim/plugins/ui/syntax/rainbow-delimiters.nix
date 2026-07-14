{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.ui;
  isRaindowDelimiters = (cfg.syntax.use == "rainbow-delimiters");
in
{
  plugins = lib.mkIf (cfg.enable && isRaindowDelimiters) {
    rainbow-delimiters = {
      enable = true;
      settings = { };
    };
  };
}
