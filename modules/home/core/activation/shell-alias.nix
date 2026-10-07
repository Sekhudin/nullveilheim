{
  lib,
  config,
  ...
}:

let
  activation = config.homeCore.activation;
in
{
  home = lib.mkIf activation.enable {
    shellAliases = lib.foldl' (
      acc: profile:
      acc
      // {
        "ssh-${profile}" = "ssh -i ~/.ssh/${profile}";
        "scp-${profile}" = "scp -i ~/.ssh/${profile}";
        "sftp-${profile}" = "sftp -i ~/.ssh/${profile}";
      }
    ) { } activation.sshKeys;
  };
}
