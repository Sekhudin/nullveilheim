{
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.ui;
  isZenMode = (cfg.focus.use == "zen-mode");
in
{
  plugins = lib.mkIf (cfg.enable && isZenMode) {
    zen-mode = {
      enable = true;
      lazyLoad = {
        settings = {
          cmd = [ "ZenMode" ];
        };
      };
      settings = { };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>mz";
            __unkeyed-2 = "<cmd>ZenMode<cr>";
            icon = icon.philosopher;
            desc = "cultivation mode";
          }
        ];
      };
    };
  };
}
