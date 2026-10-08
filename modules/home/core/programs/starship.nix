{ config, ... }:

let
  withLeftSpace = s: " ${s}";
  withRightSpace = s: "${s} ";
  defaultFormat = withRightSpace "[$symbol($version)]($style)";
in
{
  programs.starship = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
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
}
