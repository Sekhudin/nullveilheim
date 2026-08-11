{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableRofi = (cfg.launcher.use == "rofi");

  keys = {
    mod = "Super";
    ctrl = "Control";
    shift = "Shift";
    insert = "Insert";
    enter = "Return";
    left = "Left";
    right = "Right";
    up = "Up";
    down = "Down";
    space = "space";
    bracketleft = "bracketleft";
    bracketright = "bracketright";
  };

  mkBind =
    p:
    lib.concatStringsSep "," (
      [ (lib.concatStringsSep "+" p.keys) ]
      ++ lib.optional (p.alternate or [ ] != [ ]) (lib.concatStringsSep "+" (p.alternate or [ ]))
    );
in
{
  config = lib.mkIf (cfg.enable && enableRofi) {
    programs = {
      rofi.extraConfig = {
        # copy paste
        kb-primary-paste = mkBind {
          keys = [
            keys.ctrl
            keys.shift
            "v"
          ];
          alternate = [
            keys.shift
            keys.insert
          ];
        };

        kb-secondary-paste = mkBind {
          keys = [
            keys.ctrl
            "v"
          ];
          alternate = [
            keys.insert
          ];
        };

        kb-secondary-copy = mkBind {
          keys = [
            keys.ctrl
            "c"
          ];
        };

        # accept and cancel
        kb-accept-entry = mkBind {
          keys = [ keys.enter ];
        };

        kb-cancel = mkBind {
          keys = [
            keys.mod
            "q"
          ];
          alternate = [ "Escape" ];
        };

        # input
        kb-clear-line = mkBind {
          keys = [
            keys.ctrl
            "w"
          ];
        };

        kb-move-front = mkBind {
          keys = [
            keys.mod
            "0"
          ];
        };

        kb-move-end = mkBind {
          keys = [
            keys.mod
            "4"
          ];
        };

        kb-move-word-forward = mkBind {
          keys = [
            keys.ctrl
            "e"
          ];
        };

        kb-move-word-back = mkBind {
          keys = [
            keys.ctrl
            "b"
          ];
        };

        kb-move-char-forward = mkBind {
          keys = [
            keys.ctrl
            keys.bracketright
          ];
          alternate = [ keys.right ];
        };

        kb-move-char-back = mkBind {
          keys = [
            keys.ctrl
            keys.bracketleft
          ];
          alternate = [ keys.left ];
        };

        kb-remove-char-back = mkBind {
          keys = [ "BackSpace" ];
        };

        # navigation
        kb-row-left = mkBind {
          keys = [
            keys.mod
            "h"
          ];
        };

        kb-row-down = mkBind {
          keys = [
            keys.mod
            "j"
          ];
          alternate = [ keys.down ];
        };

        kb-row-up = mkBind {
          keys = [
            keys.mod
            "k"
          ];
          alternate = [ keys.up ];
        };

        kb-row-right = mkBind {
          keys = [
            keys.mod
            "l"
          ];
        };

        # mode
        kb-mode-next = mkBind {
          keys = [
            keys.mod
            keys.space
          ];
        };

        # mouse
        me-select-entry = "";
        me-accept-entry = mkBind {
          keys = [ "MousePrimary" ];
        };

        # disabled
        kb-remove-word-back = "";
        kb-remove-word-forward = "";
        kb-remove-char-forward = "";
        kb-remove-to-eol = "";
        kb-remove-to-sol = "";
        kb-transpose-chars = "";

        kb-accept-custom = "";
        kb-accept-custom-alt = "";
        kb-accept-alt = "";

        kb-delete-entry = "";

        kb-mode-previous = "";
        kb-mode-complete = "";

        kb-row-tab = "";
        kb-element-next = "";
        kb-element-prev = "";

        kb-page-prev = "";
        kb-page-next = "";

        kb-row-first = "";
        kb-row-last = "";
        kb-row-select = "";

        kb-screenshot = "";
        kb-ellipsize = "";
        kb-toggle-case-sensitivity = "";
        kb-toggle-sort = "";

        kb-custom-1 = "";
        kb-custom-2 = "";
        kb-custom-3 = "";
        kb-custom-4 = "";
        kb-custom-5 = "";
        kb-custom-6 = "";
        kb-custom-7 = "";
        kb-custom-8 = "";
        kb-custom-9 = "";
        kb-custom-10 = "";
        kb-custom-11 = "";
        kb-custom-12 = "";
        kb-custom-13 = "";
        kb-custom-14 = "";
        kb-custom-15 = "";
        kb-custom-16 = "";
        kb-custom-17 = "";
        kb-custom-18 = "";
        kb-custom-19 = "";

        kb-select-1 = "";
        kb-select-2 = "";
        kb-select-3 = "";
        kb-select-4 = "";
        kb-select-5 = "";
        kb-select-6 = "";
        kb-select-7 = "";
        kb-select-8 = "";
        kb-select-9 = "";
        kb-select-10 = "";

        kb-entry-history-up = "";
        kb-entry-history-down = "";

        kb-matcher-up = "";
        kb-matcher-down = "";
      };
    };
  };
}
