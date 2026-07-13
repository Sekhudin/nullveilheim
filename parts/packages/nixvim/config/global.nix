{ pkgs, ... }:

{
  globals = {
    mapleader = " ";
    laststatus = 3;
  };

  opts = {
    background = "dark";
    backspace = [
      "indent"
      "eol"
      "start"
    ];
    cmdheight = 0;
    compatible = false;
    conceallevel = 3;
    concealcursor = "n";
    cursorline = false;
    encoding = "utf8";
    expandtab = true;
    foldenable = false;
    foldlevel = 99;
    foldlevelstart = 99;
    laststatus = 3;
    mouse = "";
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    smarttab = true;
    tabstop = 2;
    termguicolors = true;
    wrap = false;
  };

  clipboard = {
    register = "unnamedplus";
    providers = {
      xsel = {
        enable = pkgs.stdenv.isLinux;
      };
      pbcopy = {
        enable = pkgs.stdenv.isDarwin;
      };
    };
  };
}
