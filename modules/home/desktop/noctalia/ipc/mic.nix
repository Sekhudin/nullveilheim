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

  mic = hypr.getVarValues config "mic";
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
        name = mic.up;
        text = msg "mic-volume-up";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = mic.down;
        text = msg "mic-volume-down";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = mic.toggle;
        text = msg "mic-mute";
      })
    ];
  };
}
