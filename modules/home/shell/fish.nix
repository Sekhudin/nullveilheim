{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeShellModules.fish;
  masterEnable = config.homeShellModules.enable;
  isFish = (config.homeShellModules.use == "fish");
in
{
  options.homeShellModules.fish = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "fish settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isFish) {
    home = {
      packages = with pkgs; [
        branches.stable.babelfish
        fishPlugins.colored-man-pages
        fishPlugins.done
        fishPlugins.foreign-env
        fishPlugins.forgit
        fishPlugins.pisces
        fishPlugins.puffer
        fishPlugins.fifc
        fishPlugins.bass
      ];
    };

    programs = {
      fish = lib.mkMerge [
        {
          enable = true;
          plugins = with pkgs.fishPlugins; [ nix-env ];
          interactiveShellInit = ''
            # Fish color
            set -U fish_color_command 6CB6EB --bold
            set -U fish_color_redirection DEB974
            set -U fish_color_operator DEB974
            set -U fish_color_end C071D8 --bold
            set -U fish_color_error EC7279 --bold
            set -U fish_color_param 6CB6EB
            set fish_greeting

            set -U fish_history_ignore "ls" "ll" "cd" "cd .." "clear" "exit" "history" "jobs" "rm -rf /" "kill -9*"
          '';
          functions = {
            g-ignore = "curl -sL https://www.gitignore.io/api/$argv";
            node-rpkg = ''
              ${pkgs.nodejs}/bin/node -e "console.log(Object.entries(require('./package.json').$argv[1]).map(([k,v]) => k.concat(\"@\").concat(v)).join(\"\n\") )"
            '';
          };
        }
        cfg.settings
      ];
    };
  };
}
