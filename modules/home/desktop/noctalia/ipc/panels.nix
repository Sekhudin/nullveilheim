{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  inherit (extraLib.hyprland) hypr;

  panels = hypr.getVarValues config "panels";
  msg = cmd: "noctalia msg ${cmd}";

  runtimeInputs = with pkgs; [
    noctalia
  ];
in
{
  home = lib.mkIf cfg.enable {
    packages = [
      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.launcher;
        text = msg "panel-toggle launcher";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.control;
        text = msg "panel-toggle control-center";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.settings;
        text = msg "settings-toggle";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.window;
        text = msg "window-switcher";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.session;
        text = msg "panel-toggle session";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.screenshot;
        text = msg "screenshot-annotate";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.clipboard;
        text = msg "panel-toggle clipboard";
      })
    ];
  };
}
