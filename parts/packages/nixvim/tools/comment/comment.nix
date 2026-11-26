{ config, ... }:

let
  cfg = config.nixvimTools;
  enableComment = cfg.comment == "comment";
in
{
  plugins.comment = {
    enable = enableComment;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];
    settings = { };
  };
}
