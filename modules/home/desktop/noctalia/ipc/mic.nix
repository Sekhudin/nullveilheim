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

  mic = hypr.getVarValues config "mic";
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
        name = mic.up;
        text = ipc "mic-volume-up";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = mic.down;
        text = ipc "mic-volume-down";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = mic.toggle;
        text = ipc "mic-mute";
      })
    ];
  };
}
