{
  pkgs,
  actions,
  ...
}:

let
  name = actions.media_playback;

  runtimeInputs = [ ];

  text = "swayosd-client --playerctl play-pause";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
