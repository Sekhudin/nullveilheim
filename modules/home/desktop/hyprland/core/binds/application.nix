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

  apps = {
    terminal = getVar "apps.terminal";
    browser = getVar "apps.browser";
  };
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          (mkBind {
            key = combos.mod "RETURN";
            dispatcher = dsp.exec_cmd {
              cmd = apps.terminal;
            };
            flags = {
              description = "open terminal";
            };
          })

          (mkBind {
            key = combos.mod "B";
            dispatcher = dsp.exec_cmd {
              cmd = apps.browser;
            };
            flags = {
              description = "open browser";
            };
          })
        ];
      };
    };
  };
}
