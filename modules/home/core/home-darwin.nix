{
  pkgs,
  lib,
  ...
}:

{
  home = lib.mkIf pkgs.stdenv.isDarwin {
    packages = with pkgs; [
      mas
      m-cli
      clipy
      (writeScriptBin "copy" "pbcopy")
      (writeScriptBin "paste" "pbpaste")
    ];
  };
}
