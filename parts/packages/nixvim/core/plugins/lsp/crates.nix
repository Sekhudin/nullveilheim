{ ... }:

{
  plugins.crates = {
    enable = false;
    lazyLoad.settings.ft = [ "rust" ];
  };
}
