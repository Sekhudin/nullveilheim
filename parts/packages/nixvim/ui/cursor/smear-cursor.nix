{ config, lib, ... }:

let
  cfg = config.nixvimUI;
in
{
  plugins = lib.mkIf (cfg.cursor == "smear-cursor") {
    smear-cursor = {
      enable = true;
      lazyLoad = {
        settings = {
          event = [ "InsertEnter" ];
          cmd = [ "SmearCursorToggle" ];
        };
      };
      settings = {
        hide_target_hack = true;
        never_draw_over_target = true;
      };
    };
  };
}
