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
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ ];
      availableKernelModules = [
        "nvme"
        "xhci_pci_renesas"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b1372cbb-7874-4223-9c4b-f7b6cbdfea83"; }
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a0013430-ae8a-42f8-97dd-938d936f5a64";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/19EA-BB1F";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/50072e5d-ca6a-43ef-b28f-9a6856ddb6a3";
      fsType = "ext4";
    };
  };

  hardware = {
    cpu = {
      amd = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };
}
