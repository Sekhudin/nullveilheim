{
  pkgs,
  config,
  ...
}:

let
  core = config.homeCore;
in
{
  home.packages = with pkgs; [
    gemini-cli
    slack
    telegram-desktop
    wpsoffice
  ];

  targets.genericLinux.enable = core.standalone;
  systemd.user.startServices = "sd-switch";

  gtk = {
    enable = true;
    iconTheme = {
      package = core.icon.package;
      name = core.icon.name;
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv = {
        enable = true;
      };
    };

    fastfetch = {
      enable = true;
      settings = { };
    };

    bat = {
      enable = true;
      config = {
        style = "plain";
        theme = "TwoDark";
      };
    };

    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        show_battery = false;
      };
    };

    man = {
      enable = false;
      package = pkgs.man;
      generateCaches = false;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;

    };

    dircolors = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };
  };
}
