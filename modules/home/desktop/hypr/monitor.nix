{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) hypr;

  monitors = hypr.getVarRefs config "monitors";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        (hypr.mkMonitor {
          output = "";
        })

        (hypr.mkMonitor {
          output = monitors.primary;
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
        })

        (hypr.mkMonitor {
          output = monitors.secondary;
          mode = "1920x1080@60";
          position = "1920x0";
          scale = 1;
        })
      ];
    };
  };
}
