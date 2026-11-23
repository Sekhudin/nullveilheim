{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bubblewrap
    antigravity-cli
  ];

  programs = {
    claude-code = {
      enable = true;
      settings = { };
    };

    codex = {
      enable = true;
      settings = { };
    };

    opencode = {
      enable = true;
      settings = { };
    };
  };
}
