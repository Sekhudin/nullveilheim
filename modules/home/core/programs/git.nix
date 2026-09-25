{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeCore.programs.git;
in
{
  options.homeCore.programs.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable git";
      default = true;
    };
  };

  config = {
    home = lib.mkIf cfg.enable {
      packages = with pkgs; [
        git-filter-repo
      ];
    };

    programs.git = {
      enable = cfg.enable;
      settings = {
        init = {
          defaultBranch = "main";
        };
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
          path = "${config.home.homeDirectory}/.config/git/identities.gitconfig";
        };
        url = {
          "git@gitlab.com:" = {
            insteadOf = "https://gitlab.com/";
          };
          "git@bitbucket.org:" = {
            insteadOf = "https://bitbucket.org/";
          };
        };
        alias = {
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
      };
    };
  };
}
