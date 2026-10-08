{ pkgs, ... }:

{
  home.packages = [
    pkgs.gnupg
  ];

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (p: [
      p.pass-otp
      p.pass-checkup
      p.pass-audit
      p.pass-update
    ]);
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };
}
