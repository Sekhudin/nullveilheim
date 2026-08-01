{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableAshell = (cfg.bar.use == "ashell");
  inherit (extraLib.hyprland)
    mkEvent
    getVarRef
    events
    hl
    ;

  var = getVarRef config;
  monitors = var "monitors";
in
{
  imports = [
    ./custom-modules.nix
    ./modules.nix
  ];

  config = lib.mkIf (cfg.enable && enableAshell) {
    wayland.windowManager.hyprland = {
      settings = {
        on = [
          (mkEvent {
            event = events.config.reloaded;
            action = [
              (hl.exec_cmd {
                cmd = "systemctl --user restart ashell.service";
              })
            ];
          })
        ];
      };
    };

    programs = {
      ashell = {
        enable = true;
        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };

        settings = {
          log_level = "warn";
          position = "Top";
          outputs = {
            Targets = [
              monitors.edp_1
            ];
          };

          appearance = {
            style = "Islands";
            scale_factor = 1.05;
          };

          modules = {
            left = [
              [ "Workspaces" ]
              [ "Submap" ]
            ];

            center = [
              [ "WindowTitle" ]
              [ "MediaPlayer" ]
            ];

            right = [
              [ "Tempo" ]
              [
                "SystemInfo"
                "Privacy"
              ]
              [ "Settings" ]
            ];
          };
        };
      };
    };
  };
}
