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

  media = hypr.getVarValues config "media";
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
        name = media.next;
        text = msg "media next";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = media.prev;
        text = msg "media previous";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = media.toggle;
        text = msg "media toggle";
      })
    ];
  };
}
