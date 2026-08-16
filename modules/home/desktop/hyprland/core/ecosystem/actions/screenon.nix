{
  pkgs,
  dsp,
  actions,
  ...
}:

let
  name = actions.screenon;

  runtimeInputs = with pkgs; [
    hyprland
  ];

  text = "hyprctl dispatch '${
    dsp.dpms {
      action = "enable";
    }
  }' && brightnessctl -r";
in
{
  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
