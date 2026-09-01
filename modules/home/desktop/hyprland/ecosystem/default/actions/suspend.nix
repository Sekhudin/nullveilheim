{
  pkgs,
  actions,
  ...
}:

let
  name = actions.suspend;

  runtimeInputs = [ ];

  text = "systemctl suspend";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
