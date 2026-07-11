{ lib, ... }:

{

  imports = [
    ./gpg.nix
    ./multimedia.nix
    ./pass.nix
    ./productivity.nix
    ./vcs.nix
  ];

  options.homeProgramsModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable programs modules";
      default = false;
    };
  };
}
