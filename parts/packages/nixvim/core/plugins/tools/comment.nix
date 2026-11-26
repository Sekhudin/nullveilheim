{ ... }:

{
  plugins.comment = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];
    settings = { };
  };
}
