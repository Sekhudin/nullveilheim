{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.ui;
  isTrouble = (cfg.diagnostic.use == "trouble");
in
{
  plugins = lib.mkIf (cfg.enable && isTrouble) {
    trouble = {
      enable = true;
      lazyLoad = {
        settings = {
          cmd = [ "Trouble" ];
        };
      };
      settings = { };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>xx";
            __unkeyed-2 = "<cmd>Trouble<cr>";
            desc = "diagnostics";
          }
          {
            __unkeyed-1 = "<leader>xt";
            __unkeyed-2 = "<cmd>Trouble diagnostics toggle<cr>";
            desc = "diagnostics toggle";
          }
          {
            __unkeyed-1 = "<leader>xw";
            __unkeyed-2 = "<cmd>Trouble workspace_diagnostics toggle<cr>";
            desc = "workspace diagnostics";
          }
          {
            __unkeyed-1 = "<leader>xs";
            __unkeyed-2 = ''<cmd>lua require("wtf").search()<cr>'';
            desc = "search diagnostic (web)";
          }
        ];
      };
    };
  };
}
