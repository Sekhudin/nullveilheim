{
  config,
  pkgs,
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
      shellAliases = {
        rm = "rm -i";

        # common
        cat = "${pkgs.bat}/bin/bat";
        du = "${pkgs.dust}/bin/dust";
        grep = "${pkgs.ripgrep}/bin/rg";

        # criptography
        age = "${pkgs.rage}/bin/rage";

        # gpg export
        gpg-bp = "gpg --export-options backup --export";
        gpg-bs = "gpg --export-options backup --export-secret-keys";
        gpg-r = "gpg --export-options restore --import";
        gpg-bt = "gpg --export-ownertrust";
        gpg-rt = "gpg --import-ownertrust";

        # git
        g = "git";
        g-d = "git diff";
        g-s = "git status";
        g-l = "git log --graph --oneline --all";
        g-ls = "git log --graph --oneline --all --show-signature";
        g-ld = "git log --graph --oneline --all --decorate --stat";
        g-lf = "git log --oneline --all --pretty=format:\"%h%x09%an%x09%ad%x09%s\"";
        g-fa = "git fetch --all";
        g-rc = "git rebase --continue";
        g-ri = "git rebase --interactive";
        g-tmp = "git commit -m \"temp\" --no-verify";
        g-plh = "git pull origin (git rev-parse --abbrev-ref HEAD)";
        g-psh = "git push origin (git rev-parse --abbrev-ref HEAD)";
      };
    };
  };
}
