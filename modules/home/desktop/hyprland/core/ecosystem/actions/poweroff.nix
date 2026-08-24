{
  pkgs,
  actions,
  ...
}:

let
  name = actions.poweroff;

  runtimeInputs = with pkgs; [
    hyprshutdown
  ];

  text = ''hyprshutdown -t "Shutting down..." --post-cmd "systemctl poweroff"'';
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
