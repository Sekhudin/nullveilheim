{ config, lib, ... }:

let
  homeDirectory = config.home.homeDirectory;
  obdisianTemplates = lib.mapAttrs' (
    name: vault:
    lib.nameValuePair "obsidian_${name}" {
      input_path = "${homeDirectory}/.config/noctalia/Inputs/obsidian.css";
      output_path = "${homeDirectory}/${vault.target}/.obsidian/snippets/noctalia.css";
    }
  ) config.programs.obsidian.vaults;
in
{
  programs.noctalia.settings.theme.templates.user = lib.mkMerge [
    obdisianTemplates
    {
      obsidian_default = {
        input_path = "${homeDirectory}/.config/noctalia/Inputs/obsidian.css";
        output_path = "${homeDirectory}/.config/obsidian/noctalia.css";
      };
    }
  ];
}
