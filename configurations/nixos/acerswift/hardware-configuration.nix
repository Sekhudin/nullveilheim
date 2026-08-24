{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ ];
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
      ];
    };
  };

  swapDevices = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/78e65e55-3ab2-496b-963a-3091332a8b4f";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7DF1-60CE";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  hardware = {
    cpu = {
      intel = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };

    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting = {
        enable = true;
      };

      powerManagement = {
        enable = true;
      };

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
    };
  };
}
