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

  media = hypr.getVarValues config "media";
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
        name = media.next;
        text = ipc "media next";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = media.prev;
        text = ipc "media previous";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = media.toggle;
        text = ipc "media toggle";
      })
    ];
  };
}
