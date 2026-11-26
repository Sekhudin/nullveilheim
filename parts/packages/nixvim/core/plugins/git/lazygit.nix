{ ... }:

{
  plugins.lazygit = {
    enable = true;
    settings = { };
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>G";
      __unkeyed-2 = "<cmd>LazyGit<cr>";
      desc = "lazygit";
    }
  ];
}
