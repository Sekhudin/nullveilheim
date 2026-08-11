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
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs = {
      atuin = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
        enableZshIntegration = config.programs.zsh.enable;
        settings = {
          history_filter = [
            "^\\s+"
            "^ls$"
            "^ll$"
            "^cd$"
            "^cd\\.\\.$"
            "^clear$"
            "^exit$"
            "^history$"
            "^jobs$"
            "^.*(password|passwd|pass|token|secret|key).*"
            "^rm -rf /"
            "^kill -9.*"
          ];
        };
      };

      nix-index = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
        enableZshIntegration = config.programs.zsh.enable;

      };

      dircolors = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
      };

      starship = {
        enable = true;
        enableFishIntegration = config.programs.fish.enable;
        enableZshIntegration = config.programs.zsh.enable;
        settings =
          let
            withLeftSpace = s: " ${s}";
            withRightSpace = s: "${s} ";
            defaultFormat = withRightSpace "[$symbol($version)]($style)";
          in
          {
            add_newline = true;
            command_timeout = 1000;
            cmd_duration = {
              format = withLeftSpace "[$duration]($style)";
              style = "bold #EC7279";
              show_notifications = true;
            };
            battery = {
              full_symbol = "🔋 ";
              charging_symbol = "⚡️ ";
              discharging_symbol = "💀 ";
            };
            bun = {
              format = defaultFormat;
            };
            git_branch = {
              format = withRightSpace "[$symbol$branch]($style)";
            };
            git_status = {
              format = withRightSpace "([$all_status$ahead_behind]($style))";
            };
            gcloud = {
              format = withRightSpace "[$symbol$active]($style)";
            };
            golang = {
              format = defaultFormat;
            };
            nix_shell = {
              symbol = "❄️";
              format = withRightSpace "[$symbol$state]($style)";
            };
            nix_shell = {
              impure_msg = "󰊰";
              pure_msg = "󱨧";
            };
            nodejs = {
              format = defaultFormat;
            };
            ocaml = {
              format = withRightSpace "[$symbol($version)(\($switch_indicator$switch_name\))]($style)";
            };
            package = {
              format = withRightSpace "[$symbol$version]($style)";
            };
            rust = {
              format = defaultFormat;
            };
            zig = {
              format = defaultFormat;
            };
          };
      };
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
