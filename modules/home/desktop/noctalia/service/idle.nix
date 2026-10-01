{ ... }:

{
  programs.noctalia.settings.idle = {
    behavior_order = [
      "lock"
      "screen-off"
      "suspend"
    ];
    pre_action_fade_seconds = 2.0;
    behavior = {
      lock = {
        enabled = true;
        timeout = 600;
        action = "lock";
      };
      screen-off = {
        enabled = true;
        timeout = 660;
        action = "screen_off";
      };
      suspend = {
        enabled = true;
        timeout = 900;
        action = "lock_and_suspend";
      };
    };
  };
}
