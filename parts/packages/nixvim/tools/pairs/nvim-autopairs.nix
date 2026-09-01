{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimTools;
in
{
  plugins = lib.mkIf (cfg.pairs == "nvim-autopairs") {
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
