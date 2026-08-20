{
  pkgs,
  actions,
  ...
}:

let
  name = actions.volume_down;

  runtimeInputs = [ ];

  text = "swayosd-client --output-volume -5";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
