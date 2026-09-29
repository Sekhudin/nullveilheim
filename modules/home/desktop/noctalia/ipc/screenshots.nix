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

  screenshots = hypr.getVarValues config "screenshots";
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
        name = screenshots.region;
        text = ipc "screenshot-region";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = screenshots.fullscreen;
        text = ipc "screenshot-fullscreen";
      })
    ];
  };
}
