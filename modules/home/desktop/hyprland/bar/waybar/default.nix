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
in
{
  imports = [
    ./window.nix
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
          main = {
            name = "main";
            layer = "bottom";
            position = "top";
            tooltip = false;
            output = [
              monitors.edp_1
              monitors.hdmia_1
            ];
            margin-top = styles.gaps_out;
            margin-left = styles.gaps_out;
            margin-right = styles.gaps_out;
            margin-bottom = styles.gaps_out;
            spacing = styles.gaps_in;
            modules-left = [
              "hyprland/workspaces"
              "hyprland/submap"
            ];
            modules-center = [
              "hyprland/window"
              "mpd"
            ];
            modules-right = [ "upower" ];
          };
        };

        style = composeStyle {
          includes = [
            ./window-style.nix
          ];
          args = {
            inherit
              lib
              styles
              ;
          };
          style = ''
            ${toTokenCss tokens}

            * {
              border: none;
              border-radius: 0px;
              font-family: ${font.family.monospace};
              font-size: ${toString font.sizes.bar}px;
            }

            window#waybar {
              border-radius: ${toString styles.rounding}px;
              background-color: transparent;
              color: @fg;
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
