{
  mkBind,
  mkRofi,
  pkgs,
  combos,
  dsp,
  ...
}:

let
  name = "rofi-window";

  runtimeInputs = with pkgs; [
    rofi
  ];

  text = mkRofi {
    args = [
      "-show"
      "window"
    ];
    theme-str = ''

    '';
  };
in
{
  bind = mkBind {
    key = combos.mod "W";
    dispatcher = dsp.exec_cmd {
      cmd = name;
    };
    flags = {
      description = "show all window";
    };
  };

  app = pkgs.writeShellApplication {
    inherit name text runtimeInputs;
  };
}
