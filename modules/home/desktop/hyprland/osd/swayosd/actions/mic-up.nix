{
  pkgs,
  actions,
  ...
}:

let
  name = actions.mic_up;

  runtimeInputs = [ ];

  text = "swayosd-client --input-volume +5";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
