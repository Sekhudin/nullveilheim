{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nixosDesktopModules.hyprland;
  master = config.nixosDesktopModules;
  isHyprland = (master.enable && master.use == "hyprland");

  tuigreet = (lib.getExe pkgs.tuigreet);
  mkTuigreet =
    {
      user ? "greeter",
      options ? [ ],
    }:

    let
      commandOptions = lib.concatStringsSep " " options;
    in
    {
      inherit user;
      command = "${tuigreet} ${commandOptions} --cmd start-hyprland";
    };
in
{
  options.nixosDesktopModules.hyprland = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "hyprland settings";
      default = { };
    };
  };

  config = lib.mkIf isHyprland {
    programs = {
      # window manager
      hyprland = lib.mkMerge [
        {
          enable = true;
          withUWSM = lib.mkDefault true;
          xwayland = {
            enable = lib.mkDefault true;
          };
          systemd = {
            setPath = {
              enable = lib.mkDefault true;
            };
          };
        }
        cfg.settings
      ];
    };

    # display manager
    services = {
      greetd = {
        enable = true;
        restart = !(config.services.greetd.settings ? initial_session);
        useTextGreeter = true;
        settings = {
          default_session = {
            inherit
              (mkTuigreet {
                user = "greeter";
                options = [
                  "--time"
                ];
              })
              user
              command
              ;
          };
        };
      };
    };
  };
}
