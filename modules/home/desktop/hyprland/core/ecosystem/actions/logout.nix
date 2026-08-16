{
  pkgs,
  actions,
  ...
}:

let
  name = actions.logout;

  runtimeInputs = with pkgs; [
    hyprland
  ];

  text = "hyprctl dispatch 'hl.dsp.exit()'";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
