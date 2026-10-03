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

  ipc = hypr.getVarValues config "ipc";
  msg = cmd: "noctalia msg ${cmd}";

  runtimeInputs = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
in
{
  home = lib.mkIf cfg.enable {
    packages = [
      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = ipc.help;
        text = msg "panel-toggle syaikhu/hypr-cheatsheet:cheatsheet";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = ipc.keyviz;
        text = msg "plugin h-jangra/keyviz:keylistener all toggle";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = ipc.bar;
        text = msg "bar-toggle";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = ipc.dock;
        text = msg "dock-toggle";
      })
    ];
  };
}
