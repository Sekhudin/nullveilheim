{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeCore.programs.gpg;
in
{
  options.homeCore.programs.gpg = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable gpg";
      default = true;
    };
  };

  config = {
    programs.gpg = {
      enable = cfg.enable;
      settings = {
        use-agent = true;
      };
    };

    services.gpg-agent = {
      enable = cfg.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      enableSshSupport = true;
      defaultCacheTtl = 3600;
      maxCacheTtl = 999999;
      pinentry = {
        package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
      };
    };
  };
}
