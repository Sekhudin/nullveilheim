{
  pkgs,
  actions,
  ...
}:

let
  name = actions.volume_up;

  runtimeInputs = [ ];

  text = "swayosd-client --output-volume +5";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
