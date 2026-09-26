{ ... }:

{
  networking = {
    hostName = "t14";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
