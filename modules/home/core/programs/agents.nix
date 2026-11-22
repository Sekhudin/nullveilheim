{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
