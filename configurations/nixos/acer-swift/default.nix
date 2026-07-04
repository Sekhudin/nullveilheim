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
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  nixosCoreModules = {
    enable = true;
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

  nixosDesktopModules = {
    enable = true;
    use = "gnome";
  };

  nixosHardwareModules = {
    enable = true;
  };

  nixosProgramsModules = {
    enable = true;
    steam = {
      enable = true;
    };
  };

  nixosServicesModules = {
    enable = true;
    audio = {
      enable = true;
    };

    printing = {
      enable = true;
    };

    openssh = {
      enable = true;
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
