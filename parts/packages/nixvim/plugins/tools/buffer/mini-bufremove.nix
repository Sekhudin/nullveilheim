{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isNvimBufremove = (cfg.buffer.use == "mini-bufremove");
in
{
  plugins = lib.mkIf (cfg.enable && isNvimBufremove) {
    mini-bufremove = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [ "BufReadPost" ];
        };
      };
      settings = {
        silent = false;
      };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>bd";
            __unkeyed-2 = "<cmd>lua require('mini.bufremove').wipeout()<cr>";
            desc = "close buffer";
          }
        ];
      };
    };
  };
}
