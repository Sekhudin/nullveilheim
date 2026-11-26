{
  config,
  lib,
  ...
}:

let
  cfg = config.nixvimTools;
  enableHop = cfg.motion == "hop";
in
{
  plugins.hop = {
    enable = enableHop;
    lazyLoad.settings.cmd = [ "HopLineStart" ];
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];
    settings = { };
  };

  plugins.which-key = lib.mkIf enableHop {
    settings.spec = [
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
}
