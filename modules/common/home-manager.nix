{ pkgs, ... }:

{
  home-manager = {
    backupCommand = "${pkgs.trash-cli}/bin/trash-put";
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
