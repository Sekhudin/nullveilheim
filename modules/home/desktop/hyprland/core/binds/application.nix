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
    getVar
    dsp
    combos
    ;

  terminal = getVar "apps.terminal";
  browser = getVar "apps.browser";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "RETURN";
            dispatcher = dsp.exec_cmd {
              cmd = terminal;
            };
          })

          (mkBind {
            key = combos.mod "B";
            dispatcher = dsp.exec_cmd {
              cmd = browser;
            };
          })
        ];
      };
    };
  };
}
