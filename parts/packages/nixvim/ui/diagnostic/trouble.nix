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
          # keymaps
          {
            __unkeyed-1 = "<leader>x";
            __unkeyed-2 = "<cmd>Trouble diagnostics toggle<cr>";
            desc = "diagnostics toggle";
            icon = icon.warning;
          }
          {
            __unkeyed-1 = "<leader>X";
            __unkeyed-2 = "<cmd>Trouble workspace_diagnostics toggle<cr>";
            desc = "workspace diagnostics";
          }
        ];
      };
    };
  };
}
