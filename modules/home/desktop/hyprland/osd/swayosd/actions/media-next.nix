{
  pkgs,
  actions,
  ...
}:

let
  name = actions.media_next;

  runtimeInputs = [ ];

  text = "swayosd-client --playerctl next";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
