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
    filemanager = getVar "apps.filemanager";
    windowboard = getVar "apps.windowboard";
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

          (mkBind {
            key = combos.mod "M";
            dispatcher = dsp.exec_cmd {
              cmd = apps.filemanager;
            };
            flags = {
              description = "open file manager";
            };
          })

          (mkBind {
            key = combos.mod "W";
            dispatcher = dsp.exec_cmd {
              cmd = apps.windowboard;
            };
            flags = {
              description = "windowboard toggle";
            };
          })
        ];
      };
    };
  };
}
