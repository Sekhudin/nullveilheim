{ config, ... }:

{
  programs.atuin = {
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
}
