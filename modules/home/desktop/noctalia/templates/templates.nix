{ config, lib, ... }:

let
  homeDirectory = config.home.homeDirectory;
  obdisianTemplates = lib.mapAttrs' (
    name: vault:
    lib.nameValuePair "obsidian_${name}" {
      input_path = "${homeDirectory}/.config/noctalia/inputs/obsidian.css";
      output_path = "${homeDirectory}/${vault.target}/.obsidian/snippets/noctalia.css";
    }
  ) config.programs.obsidian.vaults;
in
{
  programs.noctalia.settings.theme.templates.user = lib.mkMerge [
    obdisianTemplates
    {
      obsidian_default = {
        input_path = "${homeDirectory}/.config/noctalia/inputs/obsidian.css";
        output_path = "${homeDirectory}/.config/obsidian/noctalia.css";
      };
      telegram = {
        input_path = "${homeDirectory}/.config/noctalia/inputs/telegram.tdesktop-theme";
        output_path = "${homeDirectory}/.local/share/TelegramDesktop/noctalia.tdesktop-theme";
      };
    }
  ];
}
