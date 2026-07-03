{
  lib,
  ezModules,
  ...
}:

{
  imports = lib.attrValues ezModules ++ [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "26.05";

  users.users = {
    syaikhu = {
      isNormalUser = true;
      description = "syaikhu";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  nixosCoreModules = {
    nix = {
      settings = {
        trusted-users = [ "syaikhu" ];
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
        firewall = {
          allowedTCPPorts = [ 22 ];
        };
      };
    };
  };

  nixosServicesModules = {
    openssh = {
      settings = {
        ports = [ 22 ];
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
    };
  };
}
