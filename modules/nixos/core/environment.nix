{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      nh
      git
      curl
      wget
      fastfetch
      pciutils
      usbutils
      coreutils
      unzip
      zip
      p7zip
      ntfs3g
      dnsutils
      btop
      ripgrep
      fd
      xsel
      (writeScriptBin "copy" "xsel -ib")
      (writeScriptBin "paste" "xsel -ob")
    ];

    pathsToLink = [
      "/share/zsh"
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };
}
