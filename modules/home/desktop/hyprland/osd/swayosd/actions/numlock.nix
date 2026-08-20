{
  pkgs,
  actions,
  ...
}:

let
  name = actions.numlock;

  runtimeInputs = [ ];

  text = "sleep 0.2 && swayosd-client --num-lock";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
