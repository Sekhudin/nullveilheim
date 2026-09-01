{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimUI;
in
{
  plugins = lib.mkIf (cfg.overlay == "noice") {
    noice = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [ "VimEnter" ];
        };
      };
      settings = {
        history = {
          view = "popup";
        };
      };
    };

    which-key = {
      settings = {
        spec = [
          # group
          {
            __unkeyed-1 = "<leader>n";
            group = "noice";
          }

          # keymaps
          {
            __unkeyed-1 = "<leader>nt";
            __unkeyed-2 = "<cmd>Noice<cr>";
            desc = "noice toggle";
          }
          {
            __unkeyed-1 = "<leader>nh";
            __unkeyed-2 = "<cmd>NoiceHistory<cr>";
            desc = "noice history";
          }
          {
            __unkeyed-1 = "<leader>nf";
            __unkeyed-2 = "<cmd>NoicePick<cr>";
            desc = "noice find";
          }
          {
            __unkeyed-1 = "<leader>nd";
            __unkeyed-2 = "<cmd>NoiceDismiss<cr>";
            desc = "noice dismiss";
          }
          {
            __unkeyed-1 = "<leader>ne";
            __unkeyed-2 = "<cmd>NoiceErrors<cr>";
            desc = "noice errors";
          }
        ];
      };
    };
  };
}
