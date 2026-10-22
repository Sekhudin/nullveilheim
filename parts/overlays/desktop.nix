{ inputs, ... }:

{
  flake.overlays.desktop =
    _: prev:

    let
      system = prev.stdenv.hostPlatform.system;
      hyprland = inputs.hyprland.packages.${system};
    in
    {
      hyprland = hyprland.hyprland;
      xdg-desktop-portal-hyprland = hyprland.xdg-desktop-portal-hyprland;
      noctalia = inputs.noctalia.packages.${system}.default;
      hyprlandPlugins = prev.hyprlandPlugins // {
      };
    };
}
