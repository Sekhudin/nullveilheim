{ ... }:

{
  plugins = {
    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<Esc><Esc>";
            __unkeyed-2 = "<C-\\><C-n>";
            desc = "normal mode";
            mode = [ "t" ];
          }
          {
            __unkeyed-1 = "<leader><Esc>";
            __unkeyed-2 = "<cmd>nohlsearch<cr>";
            desc = "clear Search Highlight";
            mode = [ "n" ];
          }
        ];
      };
    };
  };
}
