{
  pkgs,
  actions,
  ...
}:

let
  name = actions.brightness_up;

  runtimeInputs = [ ];

  text = "swayosd-client --brightness +5";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
