{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isHop = (cfg.motion.use == "hop");
in
{
  plugins = lib.mkIf (cfg.enable && isHop) {
    hop = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
          cmd = [ "HopLineStart" ];
        };
      };
      settings = { };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>h";
            __unkeyed-2 = "<cmd>HopLineStart<cr>";
            desc = "seek line";
          }
          {
            __unkeyed-1 = "sc";
            __unkeyed-2 = "<cmd>HopChar2<cr>";
            desc = "seek char";
            mode = [
              "n"
              "v"
            ];
          }
          {
            __unkeyed-1 = "sl";
            __unkeyed-2 = "<cmd>HopLineStart<cr>";
            desc = "seek line";
            mode = [
              "n"
              "v"
            ];
          }
          {
            __unkeyed-1 = "sw";
            __unkeyed-2 = "<cmd>HopWord<cr>";
            desc = "seek word";
            mode = [
              "n"
              "v"
            ];
          }
        ];
      };
    };
  };
}
