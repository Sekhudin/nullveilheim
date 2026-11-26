{ config, ... }:

let
  cfg = config.nixvimUI;
  enableSmear-cursor = cfg.cursor == "smear-cursor";
in
{
  plugins.smear-cursor = {
    enable = enableSmear-cursor;
    lazyLoad.settings.event = [ "InsertEnter" ];
    lazyLoad.settings.cmd = [ "SmearCursorToggle" ];
    settings = {
      hide_target_hack = true;
      never_draw_over_target = true;
    };
  };
}
