{
  config,
  lib,
  color,
  ...
}:

let
  themeNames = lib.attrNames color.themes;
in
{
  imports = [
    ./alacritty.nix
    ./ghostty.nix
  ];

  options.homeTerminalModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable terminal modules";
      default = false;
    };

    enableCustomWM = lib.mkOption {
      type = lib.types.bool;
      description = "enable custom window manager";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "ghostty"
        "alacritty"
      ];
      description = "choose terminal";
      default = "ghostty";
    };
  };
}
