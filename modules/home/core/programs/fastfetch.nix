{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  h = extraLib.activation.mkHelper {
    context = "fastfetch";
    inherit pkgs;
  };
in
{
  programs = {
    fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos-small";
          padding.right = 2;
        };
        display.separator = "  ";
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "wm"
          "icons"
          "cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "disk"
          "localip"
          "battery"
          "locale"
          "datetime"
          "colors"
        ];
      };
    };
  };

  home.activation = lib.mkIf config.programs.fastfetch.enable {
    ${h.context} = h.makeMutableHomeFiles {
      paths = [ ".config/fastfetch/config.jsonc" ];
      mode = "600";
      inherit lib;
    };
  };
}
