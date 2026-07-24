{ lib, ... }:

{
  imports = [ ./core.nix ];

  options.nixosDesktopModules.hyprland = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "hyprland settings";
      default = { };
    };
  };
}
