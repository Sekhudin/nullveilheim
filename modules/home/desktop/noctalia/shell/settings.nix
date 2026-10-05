{ ... }:

{
  programs.noctalia.settings = {
    accessibility = {
      ui_scale = 1.0;
      high_contrast = false;
    };
    control_center = {
      sidebar = "compact";
      calendar = {
        show_events_card = true;
        show_week_numbers = false;
      };
    };
  };
}
