{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeShellModules.fish;
  masterEnable = config.homeShellModules.enable;
  isFish = (config.homeShellModules.use == "fish");
in
{
  options.homeShellModules.fish = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "fish settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isFish) {
    programs = {
      fish = lib.mkMerge [
        {
          enable = true;
          plugins = with pkgs.fishPlugins; [ nix-env ]; # nix-env -- invalid, bug: overlays not set;
        }
        cfg.settings
      ];
    };

    home = {
      packages = with pkgs; [
        babelfish
        fishPlugins.colored-man-pages
        fishPlugins.done
        fishPlugins.foreign-env
        fishPlugins.forgit
        fishPlugins.pisces
        fishPlugins.puffer
        fishPlugins.fifc
        fishPlugins.bass
      ];

    };

  };
}
