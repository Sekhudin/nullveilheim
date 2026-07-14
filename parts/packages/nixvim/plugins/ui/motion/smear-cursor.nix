{ config, lib, ... }:

let
  cfg = config.pluginsModules.ui;
  isSmearCursor = (cfg.motion.use == "smear-cursor");
in
{
  plugins = lib.mkIf (cfg.enable && isSmearCursor) {
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
