{ ... }:

{
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
        X11Forwarding = true;
        X11DisplayOffset = 10;
      };
    };
    tailscale = {
      enable = true;
    };
  };
}
