{ ... }:

{
  programs.obsidian = {
    enable = true;
    cli.enable = false;
    defaultSettings = {
      appearance = {
        theme = "obsidian";
      };
    };
    vaults = {
      personal = {
        enable = true;
        target = "Documents/Personal";
      };
      work = {
        enable = true;
        target = "Documents/Work";
      };
    };
  };
}
