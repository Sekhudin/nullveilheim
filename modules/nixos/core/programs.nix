{ ... }:

{
  programs = {
    fish = {
      enable = true;
    };

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 1";
      };
    };
  };
}
