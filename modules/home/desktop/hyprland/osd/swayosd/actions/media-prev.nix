{
  pkgs,
  actions,
  ...
}:

let
  name = actions.media_prev;

  runtimeInputs = [ ];

  text = "swayosd-client --playerctl prev";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
