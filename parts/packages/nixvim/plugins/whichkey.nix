{ ... }:

{
  plugins = {
    which-key = {
      enable = true;
      settings = {
        delay = 0;
        expand = 1;
        notify = false;
        preset = true;
        win = {
          border = "single";
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
