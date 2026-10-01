{ ... }:

{
  programs.noctalia.settings.weather = {
    enabled = true;
    effects = true;
    unit = "metric";
    refresh_minutes = 30;
  };
}
