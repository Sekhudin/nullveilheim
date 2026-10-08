{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "Host *" = {
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        ControlMaster = "auto";
        ControlPersist = "10m";
        ControlPath = "~/.ssh/control-%C";
        HashKnownHosts = true;
      };
    };
  };
}
