{
  pkgs,
  config,
  lib,
  ezModules,
  osConfig,
  extraLib,
  ...
}:

let
  homeDirectory = config.home.homeDirectory;
  ctx = extraLib.mkHomeContext {
    username = "syaikhu";
    inherit pkgs osConfig;
  };
in
{
  imports = lib.attrValues ezModules ++ [ ];

  home = {
    stateVersion = "26.05";
    username = ctx.username;
    homeDirectory = ctx.homeDirectory;
  };

  homeCore = {
    standalone = ctx.standalone;
    shell = "fish";
    terminal = "ghostty";
    theme = "aurora";
    activation = rec {
      enable = true;
      gpgKeys = [ "personal" ];
      sshKeys = gpgKeys;
      gitIdentities = gpgKeys;
    };
    packages = with pkgs; [
      nixvim
    ];
    sessionVariables = {
      EDITOR = lib.getExe' pkgs.nixvim "nvim";
      NH_FLAKE = "${homeDirectory}/.config/nullveilheim";
    };
  };

  homeDesktop = {
    enable = ctx.desktop;
    noctalia = {
      desktop.backdrop.enable = true;
    };
  };
}
