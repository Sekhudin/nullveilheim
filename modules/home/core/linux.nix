{
  config,
  pkgs,
  lib,
  ...
}:

let
  master = config.homeCoreModules;
in
{
  options.homeCoreModules.linux = { };

  config = lib.mkIf (master.enable && pkgs.stdenv.isLinux) {
    home = {
      packages = with pkgs; [
        fswatch
        copyq
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
  };
}
