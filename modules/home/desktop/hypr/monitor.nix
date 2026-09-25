{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) getVar mkMonitor;

  edp_1 = getVar "monitors.edp_1";
  hdmia_1 = getVar "monitors.hdmia_1";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        (mkMonitor {
          output = "";
        })

        (mkMonitor {
          output = edp_1;
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
        })

        (mkMonitor {
          output = hdmia_1;
          mode = "1920x1080@60";
          position = "1920x0";
          scale = 1;
        })
      ];
    };
  };
}
