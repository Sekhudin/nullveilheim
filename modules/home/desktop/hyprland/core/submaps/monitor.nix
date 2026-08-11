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

  monitor = getVar "submaps.monitor";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.alt "M";
            dispatcher = dsp.submap {
              name = monitor;
            };
            flags = {
              description = "submap monitor";
            };
          })
        ];

        define_submap = [
          (mkSubmap {
            name = monitor;
            escape = true;
            bind = [
              # focus monitor
              (mkSubmapBind {
                key = combos.plain "H";
                dispatcher = dsp.focus {
                  monitor = "-1";
                };
                flags = {
                  description = "move focus to previous monitor";
                };
              })

              (mkSubmapBind {
                key = combos.plain "L";
                dispatcher = dsp.focus {
                  monitor = "+1";
                };
                flags = {
                  description = "move focus to next monitor";
                };
              })

              # move window
              (mkSubmapBind {
                key = combos.shift "H";
                dispatcher = dsp.window.move {
                  monitor = "-1";
                };
                flags = {
                  description = "move window to previous monitor";
                };
              })
              (mkSubmapBind {
                key = combos.shift "L";
                dispatcher = dsp.window.move {
                  monitor = "+1";
                };
                flags = {
                  description = "move window to next monitor";
                };
              })

              # move workspace
              (mkSubmapBind {
                key = combos.ctrl "H";
                dispatcher = dsp.workspace.move {
                  monitor = "-1";
                };
                flags = {
                  description = "move workspace to previous monitor";
                };
              })
              (mkSubmapBind {
                key = combos.ctrl "L";
                dispatcher = dsp.workspace.move {
                  monitor = "+1";
                };
                flags = {
                  description = "move workspace to next monitor";
                };
              })
            ];
          })
        ];
      };
    };
  };
}
