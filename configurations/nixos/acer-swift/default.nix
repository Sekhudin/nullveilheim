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

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = [
        "syaikhu"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      contentAddressedByDefault = false;
      tarball-ttl = 0;
    };
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  nixosCoreModules = {
    networking = {
      settings = {
        hostName = "nixos";
        networkmanager.enable = true;
        firewall.allowedTCPPorts = [ 22 ];
      };
    };
  };

  nixosServicesModules = {
    openssh = {
      settings = {
        settings.PasswordAuthentication = true;
        settings.PermitRootLogin = "no";
      };
    };
  };
}
