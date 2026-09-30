{ ... }:

{
  programs.noctalia.settings.lockscreen = {
    enabled = true;
    lock_before_suspend = true;
    fingerprint = true;
    allow_empty_password = false;
    blurred_desktop = false;
    transition_duration = 1500;
    edge_smoothness = 0.3;
    blur_intensity = 0.5;
    tint_intensity = 0.3;
  };
}
