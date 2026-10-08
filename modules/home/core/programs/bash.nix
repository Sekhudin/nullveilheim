{ ... }:

{
  programs.bash = {
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
}
