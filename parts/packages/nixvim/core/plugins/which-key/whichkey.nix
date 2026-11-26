{ ... }:

{
  plugins.which-key = {
    enable = true;
    settings = {
      delay = 0;
      expand = 1;
      notify = false;
      preset = true;
      win = {
        border = "single";
      };
      replace = {
        desc = [
          [
            "<C-h>"
            "Ctrl+h"
          ]
          [
            "<C-l>"
            "Ctrl+l"
          ]
          [
            "<C-j>"
            "Ctrl+j"
          ]
          [
            "<C-k>"
            "Ctrl+k"
          ]
        ];
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
    };
  };
}
