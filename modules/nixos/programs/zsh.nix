{ config, lib, ... }:

let
  cfg = config.nixosProgramsModules.zsh;
  masterEnable = config.nixosProgramsModules.enable;
in
{
  options.nixosProgramsModules.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable zsh";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "zsh settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs.zsh = lib.mkMerge [
      {
        enable = true;
        enableCompletion = lib.mkDefault true;
        histSize = lib.mkDefault 5000;
        histFile = lib.mkDefault "$HOME/.zsh_history";
        promptInit = ''
          autoload -U colors && colors
          setopt prompt_subst

          PROMPT='%F{110}%n%f%F{244}@%f%F{109}%m%f %F{150}%~%f %(?.%F{108}.%F{167})>%f '
        '';

        autosuggestions = {
          enable = lib.mkDefault true;
        };

        syntaxHighlighting = {
          enable = true;
          highlighters = [
            "main"
            "brackets"
            "root"
          ];
          styles = {
            "command" = "fg=150,bold";
            "alias" = "fg=109,bold";
            "builtin" = "fg=110";
            "function" = "fg=109";
            "single-hyphen-option" = "fg=244";
            "double-hyphen-option" = "fg=244";
            "single-quoted-argument" = "fg=150";
            "double-quoted-argument" = "fg=150";
            "default" = "fg=253";
            "path" = "fg=110,underline";
            "commandseparator" = "fg=108";
            "redirection" = "fg=108";
            "unknown-token" = "fg=167,bold";
            "reserved-word" = "fg=167,bold";
          };
        };
        setOptions = [
          "AUTO_PUSHD"
          "PUSHD_IGNORE_DUPS"
          "CORRECT"
          "RM_STAR_WAIT"
          "EXTENDED_HISTORY"
          "SHARE_HISTORY"
          "HIST_IGNORE_DUPS"
          "HIST_IGNORE_SPACE"
          "HIST_VERIFY"
        ];
      }
      cfg.settings
    ];
  };
}
