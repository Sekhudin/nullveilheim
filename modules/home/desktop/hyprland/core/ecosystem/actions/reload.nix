{
  pkgs,
  actions,
  ...
}:

let
  name = actions.reload;

  runtimeInputs = with pkgs; [
    hyprland
  ];

  text = "hyprctl reload";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
