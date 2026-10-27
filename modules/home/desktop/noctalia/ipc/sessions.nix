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

  sessions = hypr.getVarValues config "sessions";
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
        name = sessions.lock;
        text = msg "session lock";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.lock_suspend;
        text = msg "session lock-and-suspend";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.logout;
        text = msg "session logout";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.reboot;
        text = msg "session reboot";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = sessions.shutdown;
        text = msg "session shutdown";
      })
    ];
  };
}
