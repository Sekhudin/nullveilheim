{
  pkgs,
  lib,
  ...
}:

{
  home = lib.mkIf pkgs.stdenv.isLinux {
    packages = with pkgs; [
      fswatch
      xsel
      (writeScriptBin "copy" "xsel -ib")
      (writeScriptBin "paste" "xsel -ob")

      # fuck
      sysz
    ];

    shellAliases = {
      fuck-systemctl = lib.getExe pkgs.sysz;
    };
  };
}
