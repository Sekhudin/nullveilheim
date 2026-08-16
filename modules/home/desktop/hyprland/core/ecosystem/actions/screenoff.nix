{
  pkgs,
  dsp,
  actions,
  ...
}:

let
  name = actions.screenoff;

  runtimeInputs = with pkgs; [
    hyprland
  ];

  text = "hyprctl dispatch '${
    dsp.dpms {
      action = "disable";
    }
  }'";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
