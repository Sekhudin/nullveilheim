{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isNvimAutopairs = (cfg.pairs.use == "nvim-autopairs");
in
{
  plugins = lib.mkIf (cfg.enable && isNvimAutopairs) {
    nvim-autopairs = { };
  };
}
