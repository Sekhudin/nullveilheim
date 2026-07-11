{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homeProgramsModules.pass;
in
{
  options.homeProgramsModules.pass = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable pass";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.gnupg ];

    programs = {
      password-store = {
        enable = cfg.enable;
        package = pkgs.pass.withExtensions (p: [
          p.pass-otp
          p.pass-checkup
          p.pass-audit
          p.pass-update
        ]);
      };

      browserpass = {
        enable = true;
        browsers = [ "firefox" ];
      };
    };

  };
}
