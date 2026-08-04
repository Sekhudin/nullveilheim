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
  inherit (color) mkGtkColor;
  inherit (extraLib.hyprland)
    mkEvent
    getVarRef
    events
    hl
    ;

  toTokenCss =
    tokens:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "@define-color ${name} ${mkGtkColor value};") tokens
    );

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

  basicSettings = {
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
            basicSettings
            {
              name = "primary";
              output = [
                monitors.edp_1
              ];
              modules-left = [
                "hyprland/workspaces"
                "hyprland/submap"
              ];
              modules-center = [
                "hyprland/window"
                "mpd"
              ];
              modules-right = [ "upower" ];
            }
          ];

          secondary = lib.mkMerge [
            basicSettings
            {
              name = "secondary";
              output = [
                monitors.hdmia_1
              ];
              modules-left = [
                "hyprland/workspaces"
                "hyprland/submap"
              ];
              modules-center = [
                "hyprland/window"
                "mpd"
              ];
              modules-right = [ ];
            }
          ];
        };

        style = composeStyle {
          includes = [
            ./window-style.nix
            ./workspaces-style.nix
          ];
          args = {
            inherit
              lib
              styles
              ;
          };
          style = ''
            ${toTokenCss tokens}

            window#waybar {
              color: @fg;
              background: transparent;
              border: none;
              border-radius: 0px;
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

            tooltip {
              border-radius: ${toString styles.rounding}px;
              opacity: 0;
            }
          '';
        };
      };
    };
  };
}
