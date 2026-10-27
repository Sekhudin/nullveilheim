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

  volume = hypr.getVarValues config "volume";
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
        name = volume.up;
        text = msg "volume-up";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = volume.down;
        text = msg "volume-down";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = volume.toggle;
        text = msg "volume-mute";
      })
    ];
  };
}
