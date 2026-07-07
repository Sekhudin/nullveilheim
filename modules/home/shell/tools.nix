{
  config,
  lib,
  ...
}:

let
  cfg = config.homeShellModules.tools;
  masterEnable = config.homeShellModules.enable;
in
{
  options.homeShellModules.tools = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable tools";
      default = true;
    };

    atuin = lib.mkOption {
      type = lib.types.attrs;
      description = "atuin settings";
      default = { };
    };

    nix-index = lib.mkOption {
      type = lib.types.attrs;
      description = "nix-index settings";
      default = { };
    };

    dircolors = lib.mkOption {
      type = lib.types.attrs;
      description = "dircolors settings";
      default = { };
    };

    zoxide = lib.mkOption {
      type = lib.types.attrs;
      description = "zoxide settings";
      default = { };
    };

    starship = lib.mkOption {
      type = lib.types.attrs;
      description = "zoxide settings";
      default = { };
    };

  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs = {
      atuin = lib.mkMerge [
        {
          enable = true;
          enableFishIntegration = config.programs.fish.enable;
          enableBashIntegration = config.programs.bash.enable;
          enableZshIntegration = config.programs.zsh.enable;
        }
        cfg.atuin
      ];

      nix-index = lib.mkMerge [
        {
          enable = true;
          enableFishIntegration = config.programs.fish.enable;
          enableBashIntegration = config.programs.bash.enable;
          enableZshIntegration = config.programs.zsh.enable;

        }
        cfg.nix-index
      ];

      dircolors = lib.mkMerge [
        {
          enable = true;
          enableFishIntegration = config.programs.fish.enable;
        }
        cfg.dircolors
      ];

      zoxide = lib.mkMerge [
        {
          enable = true;
          enableFishIntegration = config.programs.fish.enable;
        }
        cfg.zoxide
      ];

      starship = lib.mkMerge [
        {
          enable = true;
          enableFishIntegration = config.programs.fish.enable;
          enableBashIntegration = config.programs.bash.enable;
          enableZshIntegration = config.programs.zsh.enable;

        }
        cfg.starship
      ];
    };

    home = {
      sessionPath = [ "$HOME/.yarn/bin" ];
      shellAliases = { };
    };
  };
}
