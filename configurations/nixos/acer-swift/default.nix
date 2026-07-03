{
  pkgs,
  lib,
  ezModules,
  ...
}:

{
  imports = lib.attrValues ezModules ++ [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "26.05";

  users.users.syaikhu = {
    isNormalUser = true;
    description = "syaikhu";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  nixosCoreModules = {
    nix = {
      settings = {
        settings.trusted-users = [ "syaikhu" ];
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    networking = {
      settings = {
        hostName = "acer-swift";
        networkmanager.enable = true;
        firewall.allowedTCPPorts = [ 22 ];
      };
    };
  };

  nixosServicesModules = {
    openssh = {
      settings = {
        ports = [ 22 ];
        settings.PasswordAuthentication = true;
        settings.PermitRootLogin = "no";
      };
    };
  };
}
