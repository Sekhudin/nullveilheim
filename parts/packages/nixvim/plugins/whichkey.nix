{
  lib,
  ...
}:

{
  plugins = {
    which-key = {
      enable = true;
      settings = {
        delay = lib.mkDefault 0;
        expand = lib.mkDefault 1;
        notify = lib.mkDefault false;
        preset = lib.mkDefault true;
        win = {
          border = lib.mkDefault "single";
        };
        triggers = [
          {
            __unkeyed-1 = "<leader>";
            mode = "n";
          }
          {
            __unkeyed-1 = "g";
            mode = "n";
          }
        ];
        spec = [
        ];
      };
    };
  };
}
