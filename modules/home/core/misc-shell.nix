{ config, ... }:

{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      historyControl = [
        "ignorespace"
        "ignoredups"
        "ignoreboth"
      ];
      historyIgnore = [
        "ls"
        "ll"
        "cd"
        "cd .."
        "clear"
        "exit"
        "history"
        "jobs"
        "rm -rf /"
        "kill -9*"
      ];
    };

    atuin = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      settings = {
        history_filter = [
          "^\\s+"
          "^ls$"
          "^ll$"
          "^cd$"
          "^cd\\.\\.$"
          "^clear$"
          "^exit$"
          "^history$"
          "^jobs$"
          "^.*(password|passwd|pass|token|secret|key).*"
          "^rm -rf /"
          "^kill -9.*"
        ];
      };
    };

    nix-index = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;

    };

    dircolors = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };

    starship = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;
      settings =
        let
          withLeftSpace = s: " ${s}";
          withRightSpace = s: "${s} ";
          defaultFormat = withRightSpace "[$symbol($version)]($style)";
        in
        {
          add_newline = true;
          command_timeout = 1000;
          cmd_duration = {
            format = withLeftSpace "[$duration]($style)";
            style = "bold #EC7279";
            show_notifications = true;
          };
          battery = {
            full_symbol = "🔋 ";
            charging_symbol = "⚡️ ";
            discharging_symbol = "💀 ";
          };
          bun = {
            format = defaultFormat;
          };
          git_branch = {
            format = withRightSpace "[$symbol$branch]($style)";
          };
          git_status = {
            format = withRightSpace "([$all_status$ahead_behind]($style))";
          };
          gcloud = {
            format = withRightSpace "[$symbol$active]($style)";
          };
          golang = {
            format = defaultFormat;
          };
          nix_shell = {
            symbol = "❄️";
            format = withRightSpace "[$symbol$state]($style)";
          };
          nix_shell = {
            impure_msg = "󰊰";
            pure_msg = "󱨧";
          };
          nodejs = {
            format = defaultFormat;
          };
          ocaml = {
            format = withRightSpace "[$symbol($version)(\($switch_indicator$switch_name\))]($style)";
          };
          package = {
            format = withRightSpace "[$symbol$version]($style)";
          };
          rust = {
            format = defaultFormat;
          };
          zig = {
            format = defaultFormat;
          };
        };
    };
  };
}
