{
  mkPackages =
    pkgs: with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
    ];

  family = {
    monospace = "JetBrainsMono Nerd Font";
    sansSerif = "Inter";
    serif = "Noto Serif";
    emoji = "Noto Color Emoji";
  };

  sizes = {
    terminal = 11.5;
    desktop = 10;
    bar = 9.5;
  };
}
