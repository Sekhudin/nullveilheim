{
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    mkBind
    getVar
    dsp
    combos
    ;

  keys = {
    printscreen = "Print";
  };

  actions = {
    screenshot_fullscreen = getVar "actions.screenshot_fullscreen";
  };

  menus = {
    screenshot = getVar "menus.screenshot";
  };
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        (mkBind {
          key = combos.shift keys.printscreen;
          dispatcher = dsp.exec_cmd {
            cmd = actions.screenshot_fullscreen;
          };
          flags = {
            description = "screenshot fullscreen";
          };
        })

        (mkBind {
          key = combos.plain keys.printscreen;
          dispatcher = dsp.exec_cmd {
            cmd = menus.screenshot;
          };
          flags = {
            description = "show screenshot menu";
          };
        })
      ];
    };
  };
}
