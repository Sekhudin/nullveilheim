{ ... }:

{
  autoCmd = [
    {
      event = [
        "InsertLeave"
        "FocusLost"
      ];
      command = "silent update";
      pattern = [
        "*.css"
        "*.go"
        "*.js"
        "*.jsx"
        "*.md"
        "*.nix"
        "*.ts"
        "*.tsx"
      ];
    }
  ];
}
