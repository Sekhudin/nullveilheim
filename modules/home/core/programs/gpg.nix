{
  config,
  pkgs,
  ...
}:

{
  programs.gpg = {
    enable = true;
    settings = {
      use-agent = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 999999;
    pinentry = {
      package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
    };
  };
}
