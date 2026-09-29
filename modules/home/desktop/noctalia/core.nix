{
  inputs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktop;
  inherit (extraLib.hyprland)
    hypr
    events
    hl
    ;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  wayland.windowManager.hyprland.settings = lib.optionals cfg.noctalia.enable {
    on = [
      (hypr.mkEvent {
        event = events.hyprland.start;
        action = hl.exec_cmd {
          cmd = "noctalia --daemon";
        };
      })
    ];

    window_rule = [
      (hypr.mkWindowRule {
        name = "noctalia";
        match.class = "dev.noctalia.Noctalia";
        float = true;
        size = [
          1080
          920
        ];
      })
    ];

    layer_rule = [
      (hypr.mkLayerRule {
        name = "noctalia";
        match = {
          namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
        };
        no_anim = true;
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;
      })
    ];
  };

  programs.noctalia = {
    enable = cfg.noctalia.enable;
  };
}
