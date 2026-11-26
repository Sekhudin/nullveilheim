{ ... }:

{
  plugins.colorizer = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];
    settings.user_default_options = {
      mode = "virtualtext";
      virtualtext = " ■";
      RRGGBBAA = true;
      RRGGBB = true;
      AARRGGBB = true;
    };
  };
}
