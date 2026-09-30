{ config, ... }:

let
  cfg = config.homeDesktop.noctalia.desktop;
in
{
  programs.noctalia.settings.desktop_widgets = {
    enabled = cfg.widgets.enable;
    schema_version = 2;
    grid = {
      visible = true;
      cell_size = 16;
      major_interval = 4;
    };
    widget = {
    };
  };
}
