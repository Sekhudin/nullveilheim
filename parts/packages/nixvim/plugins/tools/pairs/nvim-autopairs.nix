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
    nvim-autopairs = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [ "InsertEnter" ];
        };
      };
      settings = {
        fast_wrap = {
          map = "<M-e>";
        };
        disable_filetype = [
          "alpha"
          "dashboard"
          "dbui"
          "dbout"
          "help"
          "lazy"
          "mason"
          "neo-tree"
          "neo-tree-popup"
          "noice"
          "notify"
          "spectre_panel"
          "sql"
          "qf"
          "toggleterm"
          "Outline"
          "TelescopePrompt"
          "TelescopeResults"
          "Trouble"
        ];
      };
    };
  };
}
