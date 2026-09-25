{ ... }:

{
  networking = {
    hostName = "acerswift";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
