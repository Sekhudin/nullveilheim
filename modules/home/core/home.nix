{
  pkgs,
  lib,
  font,
  ...
}:

{

  home = {
    packages =
      with pkgs;
      [
        coreutils
        gnused
        gawk
        curl
        wget
        tree
        rage
        ack

        # multi-media
        asciinema
        asciinema-agg
        ffmpeg
        imagemagick

        # productivity
        fzf
        fzy
        dust
        fd
        jq
        iamb
        ripgrep
        nixfmt
      ]
      ++ (font.mkPackages pkgs);

    sessionPath = [
      "$HOME/.yarn/bin"
    ];

    shellAliases = {
      rm = "rm -i";

      # common
      cat = lib.getExe pkgs.bat;
      du = lib.getExe pkgs.dust;
      grep = lib.getExe' pkgs.ripgrep "rg";

      # criptography
      age = lib.getExe pkgs.rage;

      # gpg export
      gpg-bp = "gpg --export-options backup --export";
      gpg-rp = "gpg --import-options restore --import";

      gpg-bs = "gpg --export-options backup --export-secret-keys";
      gpg-rs = "gpg --pinentry-mode loopback --import-options restore --import";

      gpg-bt = "gpg --export-ownertrust";
      gpg-rt = "gpg --import-ownertrust";

      # git
      g = "git";
      g-d = "git diff";
      g-s = "git status";
      g-l = "git log --graph --oneline --all";
      g-ls = "git log --graph --oneline --all --show-signature";
      g-ld = "git log --graph --oneline --all --decorate --stat";
      g-lf = "git log --oneline --all --pretty=format:\"%h%x09%an%x09%ad%x09%s\"";
      g-fa = "git fetch --all";
      g-rc = "git rebase --continue";
      g-ri = "git rebase --interactive";
      g-tmp = "git commit -m \"temp\" --no-verify";
      g-plh = "git pull origin (git rev-parse --abbrev-ref HEAD)";
      g-psh = "git push origin (git rev-parse --abbrev-ref HEAD)";
    };
  };
}
