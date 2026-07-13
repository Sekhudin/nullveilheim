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
}
