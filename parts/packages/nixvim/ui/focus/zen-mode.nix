{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.nixvimUI;
  enableZen-mode = cfg.focus == "zen-mode";
in
{
  plugins.zen-mode = {
    enable = enableZen-mode;
    lazyLoad.settings.cmd = [ "ZenMode" ];
    settings = { };
  };

  plugins.which-key = lib.mkIf enableZen-mode {
    settings.spec = [
      {
        __unkeyed-1 = "<leader>m";
        __unkeyed-2 = "<cmd>ZenMode<cr>";
        icon = icon.philosopher;
        desc = "zen mode";
      }
    ];
  };
}
