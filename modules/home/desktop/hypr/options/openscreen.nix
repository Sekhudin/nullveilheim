{
  inputs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.programs.openscreen;
  inherit (extraLib.hyprland) hypr;
in
{
  imports = [
    inputs.openscreen.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = lib.mkIf cfg.enable {
    settings.window_rule = [
      (hypr.mkWindowRule {
        name = "openscreen";
        match = {
          class = "^openscreen$";
          title = "^openscreen$";
        };
        pin = true;
        allows_input = true;
        no_focus = false;
        border_size = 0;
        move = [
          "574"
          "-32"
        ];
        suppress_event = "fullscreen maximize fullscreenoutput";
      })

      (hypr.mkWindowRule {
        name = "openscreen-editor";
        match = {
          class = "^openscreen$";
          title = "^OpenScreen$";
        };
        maximize = true;
      })
    ];
  };
}
