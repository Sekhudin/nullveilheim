{
  inputs,
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
  ipc = cmd: "noctalia msg ${cmd}";

  runtimeInputs = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
in
{
  home = lib.mkIf cfg.enable {
    packages = [
      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.launcher;
        text = ipc "panel-toggle launcher";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.control;
        text = ipc "panel-toggle control-center";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.settings;
        text = ipc "settings-toggle";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.window;
        text = ipc "window-switcher";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.session;
        text = ipc "panel-toggle session";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.screenshot;
        text = ipc "screenshot-annotate";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = panels.clipboard;
        text = ipc "panel-toggle clipboard";
      })
    ];
  };
}
