{
  pkgs,
  actions,
  ...
}:

let
  name = actions.volume_mute;

  runtimeInputs = [ ];

  text = "swayosd-client --output-volume mute-toggle";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
