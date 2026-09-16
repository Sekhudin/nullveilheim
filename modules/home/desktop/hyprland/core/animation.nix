{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland)
    mkAnimation
    mkCurve
    getVarRef
    ;

  beziers = {
    smooth = "smooth";
  };

  var = getVarRef config;
  styles = var "styles";
  speed = styles.animation_ms / 100;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        curve = [
          (mkCurve {
            name = beziers.smooth;
            options = {
              type = "bezier";
              points = [
                [
                  0.22
                  1.0
                ]
                [
                  0.36
                  1.0
                ]
              ];
            };
          })
        ];

        animation = [
          (mkAnimation {
            inherit speed;
            enabled = true;
            leaf = "windows";
            bezier = beziers.smooth;
            style = "slide";
          })

          (mkAnimation {
            inherit speed;
            enabled = true;
            leaf = "windowsMove";
            bezier = beziers.smooth;
            style = "slide";
          })
        ];
      };
    };
  };
}
