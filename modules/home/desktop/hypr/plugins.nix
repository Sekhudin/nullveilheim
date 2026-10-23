{
  pkgs,
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    events
    hl
    ;

  styles = hypr.getVarRefs config "styles";
in
{
  wayland.windowManager.hyprland = {
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
    ];

    settings.on = [
      (hypr.mkEvent {
        event = events.config.reloaded;
        action = hl.config {
          plugin = {
            hyprexpo = {
              columns = 3;
              rows = 3;
              gaps_in = styles.margin_out;
              gaps_out = styles.margin_in;
              workspace_method = "center current";
              tile_rounding_power = 2.0;
              tile_rounding = styles.border_radius;
              tile_rounding_focus = styles.border_radius;
              tile_rounding_hover = styles.border_radius;
              keynav_enable = 1;
              number_key_mode = "workspace";
            };
          };
        };
      })
    ];
  };
}
