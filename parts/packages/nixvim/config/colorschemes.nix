{ config, lib, ... }:

let
  cfg = config.configModules.colorschemes;
  plugins = config.plugins;
  isScheme = sc: sc == cfg.scheme;
in
{

  options.configModules.colorschemes = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable colorschemes";
      default = false;
    };

    scheme = lib.mkOption {
      type = lib.types.enum [
        "nightfox"
        "tokyonight"
        "kanagawa"
        "catppuccin"
      ];
      description = "choose scheme";
      default = "nightfox";
    };
  };

  config = lib.mkIf cfg.enable {
    colorschemes = {
      nightfox = {
        enable = (isScheme "nightfox");
        flavor = lib.mkDefault "carbonfox";
        settings = {
          transparent = lib.mkDefault false;
        };
      };

      oxocarbon = {
        enable = (isScheme "oxocarbon");
      };

      poimandres = {
        enable = (isScheme "poimandres");
      };

      tokyonight = {
        enable = (isScheme "tokyonight");
        settings = {
          style = lib.mkDefault "night";
          transparent = lib.mkDefault false;
        };
      };

      kanagawa = {
        enable = (isScheme "kanagawa");
        settings = {
          theme = "dragon";
          transparent = false;
          undercurl = false;
          commentStyle = {
            italic = true;
          };
          colors = {
            palette = { };
            theme = {
              wave = { };
              lotus = { };
              dragon = { };
              all = { };
            };
          };
        };
      };

      catppuccin = {
        enable = (isScheme "catppuccin");
        settings = {
          flavour = lib.mkDefault "mocha";
          disable_underline = lib.mkDefault true;
          term_colors = lib.mkDefault true;
          integrations = {
            dashboard = plugins.dashboard.enable;
            cmp = plugins.cmp.enable;
            dadbod_ui = plugins.vim-dadbod-ui.enable;
            gitsigns = plugins.gitsigns.enable;

            mini = {
              enabled = true;
              indentscope_color = "";
            };
            notify = plugins.notify.enable;
            nvimtree = plugins.nvim-tree.enable;
            treesitter = plugins.treesitter.enable;

            hop = plugins.hop.enable;
            indent_blankline = {
              enable = plugins.indent-blankline.enable;
              colored_indent_levels = false;
            };
            lsp_trouble = plugins.trouble.enable;
            neotree = plugins.neo-tree.enable;
            noice = plugins.noice.enable;
            telescope = {
              enabled = plugins.telescope.enable;
            };
            which_key = plugins.which-key.enable;
          };
          styles = {
            booleans = [
              "bold"
              "italic"
            ];
            conditionals = [
              "bold"
            ];
          };
        };
      };
    };
  };
}
