{
  pkgs,
  lib,
  ...
}:

{
  home = lib.mkIf pkgs.stdenv.isLinux {
    packages = with pkgs; [
      fswatch
      shellApplication.copy
      shellApplication.paste
      shellApplication.fuck-systemctl
    ];
  };
}
