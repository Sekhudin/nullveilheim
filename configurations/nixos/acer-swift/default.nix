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

  nix.settings.trusted-users = [
    "syaikhu"
  ];

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
