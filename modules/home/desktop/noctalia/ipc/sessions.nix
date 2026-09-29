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

  sessions = hypr.getVarValues config "sessions";
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
        name = sessions.lock;
        text = ipc "session lock";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.lock_suspend;
        text = ipc "session lock-and-suspend";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.logout;
        text = ipc "session logout";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.reboot;
        text = ipc "session reboot";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.shutdown;
        text = ipc "session shutdown";
      })
    ];
  };
}
