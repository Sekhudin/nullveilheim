{
  lib,
  ezModules,
  commonModules,
  ...
}:

{
  imports = lib.attrValues (ezModules // commonModules) ++ [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "26.05";

  users.users = {
    syaikhu = {
      description = "user syaikhu";
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
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

  commonModules = {
    enable = true;
    nix = {
      settings = {
        trusted-users = [ "syaikhu" ];
      };
    };
  };

  nixosCoreModules = {
    enable = true;
    networking = {
      settings = {
        hostName = "acer-swift";
        firewall = {
          allowedTCPPorts = [ 22 ];
        };
      };
    };
  };

  nixosDesktopModules = {
    enable = true;
    use = "gnome";
  };

  nixosHardwareModules = {
    enable = true;
  };

  nixosProgramsModules = {
    enable = true;
  };

  nixosServicesModules = {
    enable = true;
    openssh = {
      settings = {
        ports = [ 22 ];
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
    };

    virtualisation = {
      settings = {
        docker = {
          enable = true;
        };
      };
    };
  };
}
