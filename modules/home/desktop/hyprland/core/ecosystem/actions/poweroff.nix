{
  pkgs,
  actions,
  ...
}:

let
  name = actions.poweroff;

  runtimeInputs = [ ];

  text = "systemctl poweroff";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
