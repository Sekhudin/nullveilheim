{
  lib,
  pkgs,
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
      description = "user syaikhu";
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

  commonModules = {
    enable = true;
    nixpkgs = {
      enableOverlays = true;
    };

    nix = {
      settings = {
        trusted-users = [ "syaikhu" ];
      };
    };
  };

  nixosCoreModules = {
    enable = true;
    boot = {
      settings = {
        kernelModules = [ "kvm-intel" ];
      };
    };

    networking = {
      settings = {
        hostName = "acerswift";
        firewall = {
          allowedTCPPorts = [ 22 ];
        };
      };
    };
  };

  nixosDesktopModules = {
    enable = true;
    use = "hyprland";
  };

  nixosHardwareModules = {
    enable = true;
  };

  nixosProgramsModules = {
    enable = true;
  };

  nixosSecurityModules = {
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
