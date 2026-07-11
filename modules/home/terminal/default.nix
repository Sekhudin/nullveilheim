{ lib, ... }:

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
  };
}
