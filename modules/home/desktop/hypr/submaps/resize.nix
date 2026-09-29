{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    ;

  submaps = hypr.getVarRefs config "submaps";

  mkDesc = desc: "(R) ${desc}";
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (hypr.mkBind {
          key = ctl.combos.alt "R";
          dispatcher = hl.dsp.submap {
            name = submaps.resize;
          };
          flags = {
            description = mkDesc "enter resize submap";
          };
        })
      ];

      define_submap = [
        (hypr.mkSubmap {
          name = submaps.resize;
          escape = true;
          bind = [
            (hypr.mkSubmapBind {
              key = ctl.combos.plain "H";
              dispatcher = hl.dsp.window.resize {
                x = -10;
                y = 0;
                relative = true;
              };
              flags = {
                repeating = true;
                description = mkDesc "resize window left";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "J";
              dispatcher = hl.dsp.window.resize {
                x = 0;
                y = 10;
                relative = true;
              };
              flags = {
                repeating = true;
                description = mkDesc "resize window down";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "K";
              dispatcher = hl.dsp.window.resize {
                x = 0;
                y = -10;
                relative = true;
              };
              flags = {
                repeating = true;
                description = mkDesc "resize window up";
              };
            })

            (hypr.mkSubmapBind {
              key = ctl.combos.plain "L";
              dispatcher = hl.dsp.window.resize {
                x = 10;
                y = 0;
                relative = true;
              };
              flags = {
                repeating = true;
                description = mkDesc "resize window right";
              };
            })
          ];
        })
      ];
    };
  };
}
