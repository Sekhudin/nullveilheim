{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland)
    mkBind
    mkSubmap
    mkSubmapBind
    getVar
    dsp
    combos
    ;

  resize = getVar "submaps.resize";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.alt "R";
            dispatcher = dsp.submap {
              name = resize;
            };
            flags = {
              description = "submap resize";
            };
          })
        ];

        define_submap = [
          (mkSubmap {
            name = resize;
            escape = true;
            bind = [
              (mkSubmapBind {
                key = combos.plain "H";
                dispatcher = dsp.window.resize {
                  x = -10;
                  y = 0;
                  relative = true;
                };
                flags = {
                  repeating = true;
                  description = "resize left";
                };
              })

              (mkSubmapBind {
                key = combos.plain "J";
                dispatcher = dsp.window.resize {
                  x = 0;
                  y = 10;
                  relative = true;
                };
                flags = {
                  repeating = true;
                  description = "resize down";
                };
              })

              (mkSubmapBind {
                key = combos.plain "K";
                dispatcher = dsp.window.resize {
                  x = 0;
                  y = -10;
                  relative = true;
                };
                flags = {
                  repeating = true;
                  description = "resize up";
                };
              })

              (mkSubmapBind {
                key = combos.plain "L";
                dispatcher = dsp.window.resize {
                  x = 10;
                  y = 0;
                  relative = true;
                };
                flags = {
                  repeating = true;
                  description = "resize right";
                };
              })
            ];
          })
        ];
      };
    };
  };
}
