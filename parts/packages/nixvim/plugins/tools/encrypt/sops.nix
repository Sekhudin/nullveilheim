{
  pkgs,
  config,
  lib,
  icon,
  ...
}:

let
  cfg = config.pluginsModules.tools;
  isSops = (cfg.encrypt.use == "sops");
in
{
  extraPlugins = lib.mkIf (cfg.enable && isSops) (
    with pkgs.vimPlugins;
    [
      nvim-sops
    ]
  );

  extraConfigLuaPost = lib.mkIf (cfg.enable && isSops) ''
    require('nvim_sops').setup()
  '';

  plugins = lib.mkIf (cfg.enable && isSops) {
    lz-n = {
      plugins = [
        {
          __unkeyed-1 = "nvim-sops";
          cmd = [
            "SopsDecrypt"
            "SopsEncrypt"
          ];
        }
      ];
    };

    which-key = {
      settings = {
        spec = [
          # group
          {
            __unkeyed-1 = "<leader>e";
            icon = icon.secret;
            group = "secret";
          }

          # keymaps
          {
            __unkeyed-1 = "<leader>ee";
            __unkeyed-2 = "<cmd>SopsEncrypt<cr>";
            desc = "sops encrypt";
          }
          {
            __unkeyed-1 = "<leader>ed";
            __unkeyed-2 = "<cmd>SopsDecrypt<cr>";
            desc = "sops decrypt";
          }
        ];
      };
    };
  };
}
