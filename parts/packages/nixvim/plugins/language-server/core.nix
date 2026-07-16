{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.language-server;
in
{
  plugins = lib.mkIf cfg.enable {
    crates = {
      enable = false;
      lazyLoad = {
        settings = {
          ft = [ "rust" ];
        };
      };
    };

    rustaceanvim = {
      enable = false;
      lazyLoad = {
        settings = {
          ft = [ "rust" ];
        };
      };
    };

    lsp = {
      enable = true;
      servers = {
        # Bash
        bashls = {
          enable = true;
          autostart = true;
        };

        # CSS
        tailwindcss = {
          enable = true;
          autostart = true;
          filetypes = [
            "html"
            "css"
            "vue"
            "javascript"
            "typescript"
            "javascriptreact"
            "typescriptreact"
          ];
          settings = {
            tailwindCSS = {
              classFunctions = [
                "clsx"
                "cn"
                "cva"
                "tw"
                "tw\\.[a-z-]+"
              ];
              classRegex = [
                [
                  "(?:cn|clsx|tw)\\(([^)]*)\\)"
                  "(?:'|\"|`)([^'\"`]*)(?:'|\"|`)"
                ]
                [
                  "class:\\s*['\"`]([^'\"`]*)"
                  "([^'\"`]*)"
                ]
                [
                  "cva\\(([^)]*)\\)"
                  "[\"'`]([^\"'`]*)\"|'|`"
                ]
                [
                  "(?:class|className)\\s*=\\s*['\"`]([^'\"`]*)"
                  "([^'\"`]*)"
                ]
              ];
            };
          };
        };

        # Clang
        ccls = {
          enable = true;
          autostart = true;
        };

        # Docker
        dockerls = {
          enable = true;
          autostart = true;
        };

        # Go
        gopls = {
          enable = true;
          autostart = true;
          extraOptions = {
            settings = {
              gopls = {
                gofumpt = false;
                hints = {
                  assignVariableTypes = true;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = true;
                  constantValues = true;
                  functionTypeParameters = true;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
              };
              extraOptions = {
                onAttach = ''
                  client.server_capabilities.documentFormattingProvider = false
                '';
              };
            };
          };
        };

        # Java
        jdtls = {
          enable = false;
          autostart = true;
        };

        # Javascript & Typescript
        biome = {
          enable = true;
          autostart = true;
        };
        tsgo = {
          enable = false;
          autostart = true;
        };
        ts_ls = {
          enable = true;
          autostart = true;
          extraOptions = {
            root_dir = ''
              require("lspconfig.util").root_pattern(
                "tsconfig.json",
                "package.json",
                ".git"
              )
            '';
          };
        };

        # Lua
        lua_ls = {
          enable = true;
          autostart = true;
        };

        # Nix
        nixd = {
          enable = true;
          autostart = true;
          settings = {
            nixpkgs = {
              expr = ''import "${inputs.nixpkgs.outPath}" { }'';
            };
            formatting = {
              command = [ "${lib.getExe pkgs.nixfmt}" ];
            };
            diagnostic = {
              suppress = [ "sema-escaping-with" ];
            };
          };
        };

        # Python
        pyright = {
          enable = true;
          autostart = true;
        };

        # Rust
        rust_analyzer = {
          enable = true;
          autostart = true;
          installCargo = false;
          installRustc = false;
        };

        # Other
        emmet_ls = {
          enable = true;
          autostart = true;
        };
        # htmx.enable = true;
        # htmx.autostart = true;

        marksman = {
          enable = true;
          autostart = true;
        };
        yamlls = {
          enable = true;
          autostart = true;
        };
        jsonls = {
          enable = true;
          autostart = true;
          extraOptions = {
            settings = {
              json = {
                validate = {
                  enable = true;
                  schemas = [
                    {
                      url = "https://turbo.build/schema.json";
                      description = "Turbo.build configuration file";
                      fileMatch = [ "turbo.json" ];
                    }
                    {
                      url = "https://json.schemastore.org/package.json";
                      description = "npm package.json";
                      fileMatch = [
                        "package.json"
                      ];
                    }
                    {
                      url = "https://json.schemastore.org/tsconfig.json";
                      description = "Typescript compiler configuration file";
                      fileMatch = [
                        "tsconfig.json"
                        "tsconfig.*.json"
                      ];
                    }
                    {
                      url = "https://raw.githubusercontent.com/nix-community/nixd/main/nixd/docs/nixd-schema.json";
                      description = "nixd schema";
                      fileMatch = [
                        ".nixd.json"
                        "nixd.json"
                      ];
                    }
                  ];
                };
              };
            };
          };
        };
      };
    };

    which-key = {
      settings = {
        spec = [
          {
            __unkeyed-1 = "<leader>lI";
            __unkeyed-2 = "<cmd>LspInfo<cr>";
            desc = "[LSP] info";
          }
          {
            __unkeyed-1 = "<leader>li";
            __unkeyed-2 = "<cmd>LspInlay<cr>";
            desc = "[LSP] toggle inlay hints";
          }
        ];
      };
    };
  };
}
