{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.nixvimUI;
  enableTrouble = cfg.diagnostic == "trouble";
in
{
  plugins.trouble = {
    enable = enableTrouble;
    lazyLoad.settings.cmd = [ "Trouble" ];
    settings = { };
  };

  plugins.which-key = lib.mkIf enableTrouble {
    settings.spec = [
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
}
