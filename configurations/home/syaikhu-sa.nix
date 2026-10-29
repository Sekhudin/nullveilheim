{ ... }:

{
  imports = [
    ./syaikhu-mini.nix
  ];

  homeCore = {
    standalone = true;
    shell = "fish";
    terminal = "ghostty";
    theme = "aurora";
    activation = rec {
      enable = true;
      gpgKeys = [ "personal" ];
      sshKeys = gpgKeys;
      gitIdentities = gpgKeys;
    };
  };

  homeDesktop.enable = false;
}
