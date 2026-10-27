{
  pkgs,
  lib,
  ...
}:

{
  home = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    packages = with pkgs; [
      fswatch
      shellApplication.copy
      shellApplication.paste
      shellApplication.fuck-systemctl
    ];
  };
}
