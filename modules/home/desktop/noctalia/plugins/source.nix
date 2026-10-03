{ ... }:

{
  programs.noctalia.settings.plugins = {
    auto_update = "all";
    source = [
      {
        enabled = true;
        name = "official";
        kind = "git";
        location = "https://github.com/noctalia-dev/official-plugins";
      }
      {
        enabled = true;
        name = "community";
        kind = "git";
        location = "https://github.com/noctalia-dev/community-plugins";
      }
      {
        enabled = true;
        name = "local";
        kind = "path";
        location = ../local-plugins;
      }
    ];
  };
}
