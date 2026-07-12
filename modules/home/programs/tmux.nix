{
  config,
  pkgs,
  lib,
  color,
  extraLib,
  ...
}:

let
  cfg = config.homeProgramsModules.tmux;
  terminal = config.homeTerminalModules;
  masterEnable = config.homeProgramsModules.enable;

  themesColor = lib.genAttrs (lib.attrNames color.themes) (name: color.mkTheme name);
  colorTerminal = themesColor.${terminal.theme};

  inherit (extraLib.tmux)
    mkWindow
    mkEditorWindow
    mkTmuxColor
    mkShellAliases
    ;

  workspaces = {
    work = {
      session_name = "work";
      windows = [
        (mkEditorWindow {
          editor = "nvim";
          start_directory = "~/work";
          overrides = {
            focus = true;
          };
        })

        (mkWindow {
          start_directory = "~/work";
        })
      ];
    };

    projects = {
      session_name = "projects";
      windows = [
        (mkEditorWindow {
          editor = "nvim";
          start_directory = "~/projects";
          overrides = {
            focus = true;
          };
        })

        (mkWindow {
          start_directory = "~/projects";
        })
      ];
    };

    portfolio = {
      session_name = "portfolio";
      windows = [
        (mkEditorWindow {
          editor = "nvim";
          start_directory = "~/projects/portfolio";
          overrides = {
            focus = true;
          };
        })

        (mkWindow {
          start_directory = "~/projects/portfolio";
          overrides = {
            panes = [
              {
                focus = true;
                shell_command = "echo happy working!";
              }
              { shell_command = "nix run self#root"; }
              { shell_command = "npm run dev"; }
            ];
          };
        })
      ];
    };
  };
in
{
  options.homeProgramsModules.tmux = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable tmux";
      default = true;
    };

    workspaces = lib.mkOption {
      type = lib.types.attrs;
      description = "List of tmux workspaces configurations";
      default = { };
      example = {
        foo = {
          session_name = "coding";
          windows = [ { window_name = "nvim"; } ];
        };
      };
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "tmux settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    home.packages = [ pkgs.gnupg ];

    programs = {
      tmux = lib.mkMerge [
        {
          enable = true;
          mouse = lib.mkDefault false;
          newSession = lib.mkDefault false;
          reverseSplit = lib.mkDefault true;
          customPaneNavigationAndResize = lib.mkDefault true;
          prefix = lib.mkDefault "C-Space";
          resizeAmount = lib.mkDefault 10;
          terminal = lib.mkDefault "screen-256color";
          keyMode = lib.mkDefault "vi";
          tmuxp = {
            enable = true;
          };
          plugins = with pkgs.tmuxPlugins; [
            {
              plugin = yank;
              extraConfig = ''
                bind Enter copy-mode # enter copy mode

                set -g @shell_mode 'vi'
                set -g @yank_selection_mouse 'clipboard'

                run -b 'tmux bind -t vi-copy v begin-selection 2> /dev/null || true'
                run -b 'tmux bind -T copy-mode-vi v send -X begin-selection 2> /dev/null || true'
                run -b 'tmux bind -t vi-copy C-v rectangle-toggle 2> /dev/null || true'
                run -b 'tmux bind -T copy-mode-vi C-v send -X rectangle-toggle 2> /dev/null || true'
                run -b 'tmux bind -t vi-copy y copy-selection 2> /dev/null || true'
                run -b 'tmux bind -T copy-mode-vi y send -X copy-selection-and-cancel 2> /dev/null || true'
                run -b 'tmux bind -t vi-copy Escape cancel 2> /dev/null || true'
                run -b 'tmux bind -T copy-mode-vi Escape send -X cancel 2> /dev/null || true'
                run -b 'tmux bind -t vi-copy H start-of-line 2> /dev/null || true'
                run -b 'tmux bind -T copy-mode-vi H send -X start-of-line 2> /dev/null || true'
                run -b 'tmux bind -t vi-copy L end-of-line 2> /dev/null || true'
                run -b 'tmux bind -T copy-mode-vi L send -X end-of-line 2> /dev/null || true'
              '';
            }

            { plugin = resurrect; }
            {
              plugin = continuum;
              extraConfig = ''
                set -g @resurrect-strategy-nvim 'session' 
                set -g @resurrect-capture-pane-contents 'on'
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '60' # minutes
              '';
            }
          ];
          extraConfig = ''
            set -g status off

            set -g pane-border-style "${(mkTmuxColor colorTerminal.scheme.base08 "default")}"
            set -g pane-active-border-style "${(mkTmuxColor colorTerminal.scheme.base08 "default")}"
            set -sg escape-time 10 

            set -g @continuum-boot on

            bind " " choose-tree -Zw
            bind s setw synchronize-panes on
            bind S setw synchronize-panes off

            bind a new-session
            bind A kill-session

            bind w new-window
            bind W kill-window

            bind v split-pane -h
            bind V split-pane -v
            bind x kill-pane

            bind n previous-window
            bind N next-window

            bind \, command-prompt "rename-window %%"
            bind \< command-prompt "rename-session %%"

            bind \? list-keys 


            # Temporary workaround for tmux sensible issue
            set -gu default-command
            set -g default-shell "$SHELL"

            # Workaround for image
            set -gq allow-passthrough on
            set -g visual-activity off
          '';
        }
        cfg.settings
      ];
    };

    home = {
      shellAliases = (mkShellAliases (workspaces // cfg.workspaces));
    };
  };
}
