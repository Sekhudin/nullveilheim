{
  pkgs,
  actions,
  ...
}:

let
  name = actions.reboot;

  runtimeInputs = with pkgs; [
    hyprshutdown
  ];

  text = ''hyprshutdown -t "Restarting..." --post-cmd "systemctl reboot"'';
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
