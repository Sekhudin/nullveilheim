{ ... }:

{
  home-manager = {
    backupFileExtension = "backup-before-nix-home-manager";
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
