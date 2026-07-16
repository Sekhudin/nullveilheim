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
      scheme = "oxocarbon";
    };

    usercommands = {
      enable = true;
    };
  };

  pluginsModules = {
    completion = {
      enable = true;
      engine = {
        use = "cmp";
      };
      icon = {
        use = "lspkind";
      };
      snippet = {
        use = "luasnip";
      };
    };

    database = {
      enable = true;
    };

    language-server = {
      enable = true;
      formatter = {
        use = "conform-nvim";
      };
      interaction = {
        use = "lspsaga";
      };
    };

    sidebar = {
      enable = true;
      use = "neo-tree";
    };

    tools = {
      enable = true;
      buffer = {
        use = "mini-bufremove";
      };
      comment = {
        use = "comment";
      };
      markdown = {
        use = "markdown-preview";
      };
      media = {
        use = "image";
      };
      motion = {
        use = "hop";
      };
      pairs = {
        use = "nvim-autopairs";
      };
      picker = {
        use = "telescope";
      };
      tag = {
        use = "ts-autotag";
      };
      vcs = {
        use = "git";
      };
      encrypt = {
        use = "sops";
      };
    };

    ui = {
      enable = true;
      diagnostic = {
        use = "trouble";
      };
      focus = {
        use = "zen-mode";
      };
      fold = {
        use = "nvim-ufo";
      };
      indent = {
        use = "indent-blankline";
      };
      motion = {
        use = "smear-cursor";
      };
      overlay = {
        use = "noice";
      };
      status = {
        use = "lualine";
      };
      syntax = {
        use = "rainbow-delimiters";
      };
      tab = {
        use = "bufferline";
      };
    };

    which-key = {
      enable = true;
    };

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
  };
}
