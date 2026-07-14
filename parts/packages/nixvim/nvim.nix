{ extraLib, ... }:

let
  inherit (extraLib.nixvim) importModules;
in
{
  imports = importModules {
    modules = [
      ./config
      ./plugins
    ];
  };

  configModules = {
    autocmd = {
      enable = true;
      autosave = {
        enable = true;
      };
    };

    colorschemes = {
      enable = true;
      scheme = "nightfox";
    };

    usercommands = {
      enable = true;
    };
  };

  pluginsModules = {
    dashboard = {
      enable = true;
      theme = "hyper";
      configDir = "~/nullveilheim";
      banner = rec {
        header = {
          ascii = "absolute_cinema";
          head = 16;
          gap = 1;
        };
        footer = {
          ascii = header.ascii;
          tail = 8;
          gap = 1;
        };
      };
    };

    lz-n = {
      enable = true;
    };

    treesitter = {
      enable = true;
    };

    which-key = {
      enable = true;
    };

    sidebar = {
      enable = true;
      use = "neo-tree";
    };

    ui = {
      enable = true;
      indent = {
        use = "indent-blankline";
      };
      motion = {
        use = "smear-cursor";
      };
      status = {
        use = "lualine";
      };
    };
  };
}
