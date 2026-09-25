{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homeCore.programs.passwords;
in
{
  options.homeCore.programs.passwords = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable passwords";
      default = true;
    };
  };

  config = {
    home = lib.mkIf cfg.enable {
      packages = [
        pkgs.gnupg
      ];
    };

    programs.password-store = {
      enable = cfg.enable;
      package = pkgs.pass.withExtensions (p: [
        p.pass-otp
        p.pass-checkup
        p.pass-audit
        p.pass-update
      ]);
    };

    programs.browserpass = {
      enable = cfg.enable;
      browsers = [ "firefox" ];
    };
  };
}
