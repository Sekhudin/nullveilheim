{ ... }:

{
  programs.noctalia.settings.calendar = {
    enabled = true;
    refresh_minutes = 15;
    event_date_format = "%A %e %B";
    event_time_format = "%H:%M";
    reminders = {
      enabled = true;
      use_event_reminders = true;
    };
    account = {
      personal_google = {
        type = "google";
        name = "Personal";
      };
    };
  };
}
