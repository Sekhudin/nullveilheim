{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
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
    ./modules.nix
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
            output = [ monitors.edp_1 ];
            modules-left = [
              "hyprland/workspaces"
              "hyprland/submap"
            ];
            modules-center = [ "hyprland/window" ];
            modules-right = [ ];
          };
        };
      };
    };
  };
}
