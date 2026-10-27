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

  screenshots = hypr.getVarValues config "screenshots";
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
        name = screenshots.region;
        text = msg "screenshot-region";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = screenshots.fullscreen;
        text = msg "screenshot-fullscreen";
      })
    ];
  };
}
