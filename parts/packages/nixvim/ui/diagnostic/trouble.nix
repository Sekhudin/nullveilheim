{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.nixvimUI;
in
{
  plugins = lib.mkIf (cfg.diagnostic == "trouble") {
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
          # group
          {
            __unkeyed-1 = "<leader>x";
            group = "diagnotics";
            icon = icon.warning;
          }

          # keymaps
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
        ];
      };
    };
  };
}
