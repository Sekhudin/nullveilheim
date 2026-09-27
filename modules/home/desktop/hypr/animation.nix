{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) hypr;

  beziers = {
    smooth = "smooth";
  };

  styles = hypr.getVarValues config "styles";
  speed = styles.animation_ms / 100;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      curve = [
        (hypr.mkCurve {
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
        (hypr.mkAnimation {
          inherit speed;
          enabled = true;
          leaf = "windows";
          bezier = beziers.smooth;
          style = "slide";
        })

        (hypr.mkAnimation {
          inherit speed;
          enabled = true;
          leaf = "windowsMove";
          bezier = beziers.smooth;
          style = "slide";
        })
      ];
    };
  };
}
