{
  pkgs,
  ...
}:

{
  extraPlugins = with pkgs.vimPlugins; [
    nvim-sops
  ];

  extraConfigLuaPost = ''
    require('nvim_sops').setup()
  '';

  plugins.lz-n.plugins = [
    {
      __unkeyed-1 = "nvim-sops";
      cmd = [
        "SopsDecrypt"
        "SopsEncrypt"
      ];
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>s";
      __unkeyed-2 = "<cmd>SopsEncrypt<cr>";
      desc = "sops encrypt";
    }
    {
      __unkeyed-1 = "<leader>S";
      __unkeyed-2 = "<cmd>SopsDecrypt<cr>";
      desc = "sops decrypt";
    }
  ];
}
