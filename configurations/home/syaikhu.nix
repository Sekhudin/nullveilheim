{
  inputs,
  pkgs,
  config,
  lib,
  ezModules,
  osConfig,
  extraLib,
  ...
}:

let
  packages = inputs.self.packages;
  system = pkgs.stdenv.hostPlatform.system;
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
    activation = true;
    standalone = ctx.standalone;
    shell = "fish";
    terminal = "ghostty";
    theme = "zenwritten_dark";
    programs = {
      secrets = rec {
        gpgKeys = [ "personal" ];
        sshKeys = gpgKeys;
        gitIdentities = gpgKeys;
      };
      jujutsu = {
        user = {
          name = "sekhudin";
          email = "sekhudinuap@gmail.com";
        };
      };
    };
    packages = [
      packages.${system}.nvim
    ];
    sessionVariables = {
      EDITOR = lib.getExe' packages.${system}.nvim "nvim";
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
