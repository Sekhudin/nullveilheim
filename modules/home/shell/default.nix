{ lib, extraLib, ... }:

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

  options.homeShellModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable shell modules";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "zsh"
        "fish"
      ];
      description = "choose shell";
      default = "fish";
    };
  };

  config = {
    programs = {
      bash = {
        enable = true;
        enableCompletion = true;
        historyControl = [
          "ignorespace"
          "ignoredups"
          "ignoreboth"
        ];
        historyIgnore = [
          "ls"
          "ll"
          "cd"
          "cd .."
          "clear"
          "exit"
          "history"
          "jobs"
          "rm -rf /"
          "kill -9*"
        ];
      };
    };
  };
}
