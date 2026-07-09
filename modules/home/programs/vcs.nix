{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeProgramsModules.vcs;
  masterEnable = config.homeProgramsModules.enable;
in
{
  options.homeProgramsModules.vcs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable vcs";
      default = true;
    };

    git = lib.mkOption {
      type = lib.types.attrs;
      description = "git settings";
      default = { };
    };

    gh = lib.mkOption {
      type = lib.types.attrs;
      description = "gh settings";
      default = { };
    };

    gh-dash = lib.mkOption {
      type = lib.types.attrs;
      description = "gh-dash settings";
      default = { };
    };

    jujutsu = lib.mkOption {
      type = lib.types.attrs;
      description = "jujutsu settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs = {
      git = lib.mkMerge [
        {
          enable = true;
          aliases = {
            a = "add";
            aa = "add .";

            c = "commit";
            ca = "commit --amend";
            can = "commit --amend --no-edit";

            r = "rebase";
            ri = "rebase -i";
            rc = "rebase --continue";
            ra = "rebase --abort";
            ro = "rebase origin/main";

            f = "fetch";
            fa = "fetch --all";

            co-a = "!f() { git checkout --ours -- \"\${@:-.}\"; git add -u \"\${@:-.}\"; }; f";
            co-e = "!f() { git checkout --theirs -- \"\${@:-.}\"; git add -u \"\${@:-.}\"; }; f";

            b = "branch";
            bs = ''
              branch --sort=-committerdate --format='%(HEAD)%(color:yellow) %(refname:short)
              | %(color:bold red)%(committername) | %(color:bold green)%(committerdate:relative)
              | %(color:blue)%(subject)%(color:reset)' --color=always
            '';
          };

          extraConfig = {
            gpg = {
              program = "gpg";
            };
            rerere = {
              enable = true;
            };
            commit = {
              gpgSign = true;
            };
            pull = {
              ff = "only";
            };
            diff = {
              tool = "vimdiff";
            };
            difftool = {
              prompt = false;
            };
            merge = {
              tool = "vimdiff";
            };
            include = {
              path = "~/.config/git/identities.gitconfig";
            };
            url = {
              "git@gitlab.com:" = {
                insteadOf = "https://gitlab.com/";
              };
              "git@bitbucket.org:" = {
                insteadOf = "https://bitbucket.org/";
              };
            };
          };
        }
        cfg.git
      ];

      gh = lib.mkMerge [
        {
          enable = true;
          settings = {
            git_protocol = "ssh";
            aliases = {
              co = "pr checkout";
              pv = "pr view";
            };
          };
        }
        cfg.gh
      ];

      gh-dash = lib.mkMerge [
        {
          enable = true;
        }
        cfg.gh-dash
      ];

      jujutsu = lib.mkMerge [
        {
          enable = true;
        }
        cfg.jujutsu
      ];
    };

    home = {
      packages = with pkgs; [
        git-filter-repo
      ];
    };
  };
}
