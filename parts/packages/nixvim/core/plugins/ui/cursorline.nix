{ ... }:

{
  plugins.cursorline = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];
    settings = {
      cursorline = {
        enable = true;
        number = true;
        timeout = 0;
      };
      cursorword = {
        enable = true;
        hl.underline = false;
      };
    };
  };
}
