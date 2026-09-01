{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableAshell = (cfg.bar.use == "ashell");
  inherit (extraLib) mkImports;
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
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  config = lib.mkIf (cfg.enable && enableAshell) {
    wayland.windowManager.hyprland = {
      settings = {
        on = [
          (mkEvent {
            event = events.config.reloaded;
            action = [
              (hl.exec_cmd {
                cmd = "systemctl --user enable --now ashell.service";
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
        };

        settings = {
          log_level = "warn";
          position = "Top";
          layer = "Bottom";
          outputs = {
            Targets = [
              monitors.edp_1
              monitors.hdmia_1
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
