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

  menus = hypr.getVarValues config "menus";
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
        name = menus.help;
        text = ipc "";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.launcher;
        text = ipc "panel-toggle launcher";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.control;
        text = ipc "panel-toggle control-center";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.settings;
        text = ipc "settings-toggle";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.window;
        text = ipc "window-switcher";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.session;
        text = ipc "panel-toggle session";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.screenshot;
        text = ipc "screenshot-annotate";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.clipboard;
        text = ipc "panel-toggle clipboard";
      })
    ];
  };
}
