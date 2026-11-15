{ config, ... }:

let
  core = config.homeCore;
in
{
  programs.herdr = {
    enable = core.multiplexer == "herdr";
    settings = {
      onboarding = false;
      keys = {
        prefix = "ctrl+space";
        workspace_picker = "";
        goto = "prefix+space";

        new_workspace = "prefix+a";
        close_workspace = "prefix+shift+a";

        new_tab = "prefix+w";
        close_tab = "prefix+shift+w";

        split_vertical = "prefix+v";
        split_horizontal = "prefix+shift+v";
        close_pane = "prefix+x";

        focus_pane_left = "prefix+h";
        focus_pane_down = "prefix+j";
        focus_pane_up = "prefix+k";
        focus_pane_right = "prefix+l";

        resize_pane_left = "prefix+shift+h";
        resize_pane_down = "prefix+shift+j";
        resize_pane_up = "prefix+shift+k";
        resize_pane_right = "prefix+shift+l";

        previous_tab = "prefix+n";
        next_tab = "prefix+shift+n";
        rename_tab = "prefix+comma";
        rename_workspace = "prefix+shift+comma";

        copy_mode = "prefix+enter";
        help = "prefix+?";
      };

      ui = {
        mouse_capture = true;
      };
    };
  };
}
