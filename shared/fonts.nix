{
  mkFont = {
    mkPackages =
      pkgs: with pkgs; [
        inter
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
      ];

    family = {
      monospace = "JetBrainsMono Nerd Font";
      sans_serif = "Inter";
      serif = "Noto Serif";
      emoji = "Noto Color Emoji";
    };

    sizes = {
      terminal = 11.5;
      desktop = 10;
      bar = 10;
    };
  };
}
