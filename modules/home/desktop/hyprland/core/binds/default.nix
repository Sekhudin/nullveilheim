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
    dsp
    combos
    directions
    ;
in
{
  imports = [
    ./application.nix
    ./session.nix
    ./window.nix
    ./workspace.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "SPACE";
            dispatcher = dsp.extra.layout_toggle {
              var_layouts = "layouts";
            };
          })

          (mkBind {
            key = combos.mod "Z";
            dispatcher = dsp.extra.zen_mode { };
          })

          (mkBind {
            key = combos.mod "Q";
            dispatcher = dsp.window.close { };
            flags = {
              locked = true;
            };
          })

          (mkBind {
            key = combos.mod "F";
            dispatcher = dsp.window.fullscreen {
              mode = "maximized";
              action = "toggle";
              layout_aware = true;
            };
          })

          (mkBind {
            key = combos.mod "V";
            dispatcher = dsp.window.float {
              action = "toggle";
            };
          })

          # focus navigation
          (mkBind {
            key = combos.mod "H";
            dispatcher = dsp.focus {
              direction = directions.left;
            };
          })

          (mkBind {
            key = combos.mod "J";
            dispatcher = dsp.focus {
              direction = directions.down;
            };
          })

          (mkBind {
            key = combos.mod "K";
            dispatcher = dsp.focus {
              direction = directions.up;
            };
          })

          (mkBind {
            key = combos.mod "L";
            dispatcher = dsp.focus {
              direction = directions.right;
            };
          })
        ];
      };
    };
  };
}
