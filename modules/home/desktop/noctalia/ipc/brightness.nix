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

  brightness = hypr.getVarValues config "brightness";
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
        name = brightness.up;
        text = msg "brightness-up";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = brightness.down;
        text = msg "brightness-down";
      })
    ];
  };
}
