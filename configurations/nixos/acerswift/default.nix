{
  lib,
  pkgs,
  ezModules,
  ...
}:

{
  imports = lib.attrValues ezModules ++ [
    ./hardware-configuration.nix
    ./networking.nix
    ./services.nix
    ./virtualisation.nix
  ];

  system.stateVersion = "26.05";

  users.users = {
    syaikhu = {
      description = "syaikhu";
      isNormalUser = true;
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      extraGroups = [
        "networkmanager"
        "adbusers"
        "input"
        "wheel"
        "kvm"
      ];
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];

    };
  };

  common = {
    nix = {
      trusted-users = [
        "syaikhu"
      ];
    };
  };

  nixosDesktop = {
    enable = true;
    apps = {
      android-studio.enable = true;
      steam.enable = true;
    };
  };
}
