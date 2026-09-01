{
  pkgs,
  lib,
  ...
}:

let
  resolveGrammarPkgs =
    gs:
    map (
      x:
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.${x} or pkgs.tree-sitter-grammars."tree-sitter-${x}"
    ) (lib.lists.unique gs);
in
{

  plugins = {
    treesitter = {
      enable = true;
      highlight = {
        enable = true;
      };
      indent = {
        enable = true;
      };
      folding = {
        enable = true;
      };
      grammarPackages = resolveGrammarPkgs [
        # Core
        "bash"
        "nix"
        "vim"
        "vimdoc"

        # Web / Scripting
        "graphql"
        "javascript"
        "typescript"
        "tsx"
        "json"
        "yaml"
        "toml"
        "css"
        "html"

        # Backend / tooling
        "sql"
        "http"
        "python"
        "rust"
        "go"
        "gomod"
        "gosum"
        "gotmpl"
        "proto"
        "textproto"

        # Infra
        "dockerfile"
        "terraform"
        "helm"
        "hcl"

        # Docs
        "comment"
        "markdown"
        "markdown_inline"
        "norg"
        "norg-meta"

        # Misc useful
        "regex"
        "query"
        "gitcommit"
        "gitignore"
        "gitattributes"
        "git_config"
        "git_rebase"
        "diff"
      ];
    };
  };
}
