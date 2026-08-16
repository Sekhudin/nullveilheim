{
  pkgs,
  actions,
  ...
}:

let
  name = actions.hibernate;

  runtimeInputs = [ ];

  text = "systemctl hibernate";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
