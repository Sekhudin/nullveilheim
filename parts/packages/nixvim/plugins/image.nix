{
  lib,
  ...
}:

{
  plugins = {
    image = {
      enable = lib.mkDefault true;
      settings = { };
    };

    which-key = {
      settings = {
        spec = [
        ];
      };
    };
  };
}
