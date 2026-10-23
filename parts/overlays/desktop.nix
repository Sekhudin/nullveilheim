{ inputs, ... }:

{
  flake.overlays.desktop =
    _: prev:

    let
      system = prev.stdenv.hostPlatform.system;
      hypr = inputs.hyprland.packages.${system};
    in
    {
      hyprland = inputs.hyprexpo.packages.${system}.hyprland;
      xdg-desktop-portal-hyprland = hypr.xdg-desktop-portal-hyprland;
      noctalia = inputs.noctalia.packages.${system}.default;
      hyprlandPlugins = prev.hyprlandPlugins // {
        hyprexpo = inputs.hyprexpo.packages.${system}.default;
      };
    };
}
