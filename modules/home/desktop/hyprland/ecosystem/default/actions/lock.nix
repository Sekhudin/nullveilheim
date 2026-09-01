{
  pkgs,
  actions,
  ...
}:

let
  name = actions.lock;

  runtimeInputs = with pkgs; [
    hyprlock
  ];

  text = "hyprlock";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
