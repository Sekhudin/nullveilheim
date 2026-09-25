{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nixosDesktop;
  tuigreet = lib.getExe pkgs.tuigreet;
in
{
  services.greetd = {
    enable = cfg.enable;
    restart = !(config.services.greetd.settings ? initial_session);
    useTextGreeter = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${tuigreet} --time --cmd start-hyprland";
      };
    };
  };
}
