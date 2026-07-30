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
    getVar
    combos
    dsp
    ;

  _var_resize = "submaps.resize";
  resize = (getVar _var_resize);
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.alt "R";
            dispatcher = dsp.submap {
              name = _var_resize;
            };
          })
        ];

        define_submap = [
          (mkSubmap {
            name = resize;
            escape = true;
            binds = ''
              hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
              hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
              hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })
              hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true}), { repeating = true })
            '';
          })
        ];
      };
    };
  };
}
