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

  volume = hypr.getVarValues config "volume";
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
        name = volume.up;
        text = ipc "volume-up";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = volume.down;
        text = ipc "volume-down";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = volume.toggle;
        text = ipc "volume-mute";
      })
    ];
  };
}
