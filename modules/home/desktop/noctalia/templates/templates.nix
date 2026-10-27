{ config, lib, ... }:

let
  homeDirectory = config.home.homeDirectory;

  inputsDirectory = "${homeDirectory}/.config/noctalia/inputs";

  obdisianTemplates = lib.mapAttrs' (
    name: vault:
    lib.nameValuePair "obsidian_${name}" {
      input_path = "${inputsDirectory}/obsidian.css";
      output_path = "${homeDirectory}/${vault.target}/.obsidian/snippets/noctalia.css";
    }
  ) config.programs.obsidian.vaults;
in
{
  programs.noctalia.settings.theme.templates.user = lib.mkMerge [
    obdisianTemplates
    {
      obsidian_default = {
        input_path = "${inputsDirectory}/obsidian.css";
        output_path = "${homeDirectory}/.config/obsidian/noctalia.css";
      };
      telegram = {
        input_path = "${inputsDirectory}/telegram.tdesktop-theme";
        output_path = "${homeDirectory}/.local/share/TelegramDesktop/noctalia.tdesktop-theme";
      };
      yakc = {
        input_path = "${inputsDirectory}/yakc.json";
        output_path = "${homeDirectory}/.config/dev.iammodev.yakc/config.json";
      };
    }
  ];
}
