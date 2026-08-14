{
  mkBind,
  joinPipe,
  pkgs,
  menus,
  combos,
  dsp,
  ...
}:

let
  name = menus.power;

  runtimeInputs = with pkgs; [
    hyprland
    rofi
    jq
  ];

  text = joinPipe [ ];
in
{
  bind = mkBind {
    key = combos.mod "escape";
    dispatcher = dsp.exec_cmd {
      cmd = name;
    };
    flags = {
      description = "show powermenu";
    };
  };

  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
