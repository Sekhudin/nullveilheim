{
  pkgs,
  config,
  lib,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableRofi = (cfg.launcher.use == "rofi");

  terminal = pkgs.${config.homeTerminalModules.use};
in
{
  imports = [
    ./bind.nix
    ./extra-config.nix
    ./key-binds.nix
    ./pass.nix
    ./theme.nix
  ];

  config = lib.mkIf (cfg.enable && enableRofi) {
    programs = {
      rofi = {
        enable = true;
        location = "center";
        xoffset = 0;
        yoffset = 0;
        font = font.family.monospace;
        terminal = lib.getExe terminal;
        plugins = [ ];
        modes = [
          "combi"
          "drun"
          "ssh"
          "window"
        ];
      };
    };
  };
}
