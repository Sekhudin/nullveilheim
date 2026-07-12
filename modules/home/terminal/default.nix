{ lib, color, ... }:

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

    use = lib.mkOption {
      type = lib.types.enum [
        "ghostty"
        "alacritty"
      ];
      description = "choose terminal";
      default = "ghostty";
    };

    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      description = "theme settings";
      default = builtins.elemAt themeNames 0;
    };
  };
}
