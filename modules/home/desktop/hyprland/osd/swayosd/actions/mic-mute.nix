{
  pkgs,
  actions,
  ...
}:

let
  name = actions.mic_mute;

  runtimeInputs = [ ];

  text = "swayosd-client --input-volume mute-toggle";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
