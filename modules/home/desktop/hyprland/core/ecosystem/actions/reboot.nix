{
  pkgs,
  actions,
  ...
}:

let
  name = actions.reboot;

  runtimeInputs = [ ];

  text = "systemctl reboot";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
