{
  pkgs,
  ...
}:

{
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
  };
}
