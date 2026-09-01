{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib)
    mkImports
    importModules
    ;
  inherit (extraLib.hyprland)
    mkEvent
    getVarRef
    events
    hl
    ;

  var = getVarRef config;
  monitors = var "monitors";
  styles = var "styles";
  actions = var "actions";

  commonSettings = {
    layer = "bottom";
    position = "top";
    fixed-center = true;
    tooltip = false;
    height = styles.min_height;
    margin-top = styles.gaps_out;
    margin-left = styles.gaps_out;
    margin-right = styles.gaps_out;
    margin-bottom = styles.gaps_out;
    spacing = styles.gaps_in;
  };
in
{
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  config = lib.mkIf (cfg.enable && enableWaybar) {
    home = {
      packages = map (module: module.app) (importModules {
        dir = ./actions;
        recursive = false;
        excludeDefault = true;
        args = {
          inherit
            pkgs
            actions
            ;
        };
      });
    };

    wayland.windowManager.hyprland = {
      settings = {
        on = [
          (mkEvent {
            event = events.config.reloaded;
            action = [
              (hl.exec_cmd {
                cmd = "systemctl --user enable --now waybar.service";
              })
            ];
          })
        ];
      };
    };

    programs = {
      waybar = {
        enable = true;
        systemd = {
          enable = true;
        };

        settings = {
          primary = lib.mkMerge [
            commonSettings
            {
              name = "primary";
              output = [
                monitors.edp_1
              ];
              modules-left = [
                "custom/nixosicon"
                "hyprland/workspaces"
                "hyprland/submap"
                "group/screen-recorder"
                "clock"
              ];
              modules-center = [
                "hyprland/window"
              ];
              modules-right = [
                "tray"
                "memory"
                "idle_inhibitor"
                "pulseaudio"
                "network"
                "bluetooth"
                "power-profiles-daemon"
                "battery"
                "custom/power"
              ];
            }
          ];

          secondary = lib.mkMerge [
            commonSettings
            {
              name = "secondary";
              output = [
                monitors.hdmia_1
              ];
              modules-left = [
                "custom/nixosicon"
                "hyprland/workspaces"
                "hyprland/submap"
                "clock"
              ];
              modules-center = [
                "hyprland/window"
              ];
              modules-right = [
                "tray"
                "memory"
                "idle_inhibitor"
                "pulseaudio"
                "network"
                "bluetooth"
                "power-profiles-daemon"
                "battery"
                "custom/power"
              ];
            }
          ];
        };
      };
    };
  };
}
