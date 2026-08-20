{
  pkgs,
  actions,
  ...
}:

let
  name = actions.capslock;

  runtimeInputs = [ ];

  text = "sleep 0.2 && swayosd-client --caps-lock";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
