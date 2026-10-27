{ inputs, ... }:

{
  flake.overlays.desktop =
    _: prev:

    let
      system = prev.stdenv.hostPlatform.system;
      hypr = inputs.hyprland.packages.${system};
    in
    {
      noctalia = inputs.noctalia.packages.${system}.default;

      hyprland = inputs.hyprexpo.packages.${system}.hyprland;
      xdg-desktop-portal-hyprland = hypr.xdg-desktop-portal-hyprland;
      hyprlandPlugins = prev.hyprlandPlugins // {
        hyprexpo = inputs.hyprexpo.packages.${system}.default;
      };
    };
}
