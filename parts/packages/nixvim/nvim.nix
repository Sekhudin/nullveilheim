{ ... }:

{
  imports = [
    ./config
    ./plugins
  ];

  configModules = {
    autocmd = {
      enable = true;
      autosave = {
        enable = true;
      };
    };

    colorschemes = {
      enable = true;
      scheme = "nightfox";
    };

    usercommands = {
      enable = true;
    };
  };

  pluginsModules = {
    dashboard = {
      theme = "hyper";
      configDir = "~/nullveilheim";
      banner = rec {
        header = {
          ascii = "absolute_cinema";
          head = 16;
          gap = 1;
        };
        footer = {
          ascii = header.ascii;
          tail = 8;
          gap = 1;
        };
      };
    };
  };
}
