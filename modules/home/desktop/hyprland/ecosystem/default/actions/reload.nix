{
  pkgs,
  actions,
  ...
}:

let
  name = actions.reload;

  runtimeInputs = [ ];

  text = "hyprctl reload";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
