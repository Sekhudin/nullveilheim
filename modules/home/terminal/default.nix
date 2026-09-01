{
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkImports;
in
{
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

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
