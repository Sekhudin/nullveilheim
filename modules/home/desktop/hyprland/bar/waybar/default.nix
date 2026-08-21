{
  config,
  lib,
  extraLib,
  color,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (color) toGtkTokenCss;
  inherit (extraLib.hyprland)
    mkEvent
    getVarRef
    events
    hl
    ;

  composeStyle =
    {
      style ? "",
      includes ? [ ],
      args ? { },
    }:
    lib.concatStringsSep "\n" (
      lib.filter (s: s != "") ([ style ] ++ map (path: import path args) includes)
    );

  var = getVarRef config;
  monitors = var "monitors";
  styles = var "styles";
  tokens = var "tokens";

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
  imports = [
    ./battery.nix
    ./bluetooth.nix
    ./clock.nix
    ./idle-inhibitor.nix
    ./network.nix
    ./nixosicon.nix
    ./power.nix
    ./powerprofile.nix
    ./pulseaudio.nix
    ./submap.nix
    ./window.nix
    ./workspaces.nix
  ];

  config = lib.mkIf (cfg.enable && enableWaybar) {
    wayland.windowManager.hyprland = {
      settings = {
        on = [
          (mkEvent {
            event = events.config.reloaded;
            action = [
              (hl.exec_cmd {
                cmd = "systemctl --user start waybar.service";
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
                "clock"
              ];
              modules-center = [
                "hyprland/window"
              ];
              modules-right = [
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

        style = composeStyle {
          includes = [
            ./battery-style.nix
            ./bluetooth-style.nix
            ./clock-style.nix
            ./idle-inhibitor-style.nix
            ./network-style.nix
            ./nixosicon-style.nix
            ./power-style.nix
            ./powerprofile-style.nix
            ./pulseaudio-style.nix
            ./submap-style.nix
            ./window-style.nix
            ./workspaces-style.nix
          ];
          args = {
            inherit
              lib
              font
              styles
              ;
          };
          style = ''
            ${toGtkTokenCss tokens}

            window#waybar {
              all: unset;
              color: @fg;
              background: transparent;
              font-family: ${font.family.monospace};
              font-size: ${toString font.sizes.bar}px;
            }

            window#waybar button {
              color: inherit;
              background: transparent;
              border: none;
              border-radius: 0;
              box-shadow: none;
              padding: 0;
              margin: 0;
              min-width: 0;
              min-height: 0;
              text-shadow: none;
            }
          '';
        };
      };
    };
  };
}
