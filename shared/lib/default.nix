let
  activation = import ./activation.nix;
  devshell = import ./devshell.nix;
  nixvim = import ./nixvim.nix;
  hyprland = import ./hyprland.nix;
  sops = import ./sops.nix;
  tmux = import ./tmux.nix;
in
{
  mkExtraLib =
    { lib }:

    {
      activation = activation.mkExtraLib { inherit lib; };

      devshell = devshell.mkExtraLib { inherit lib; };

      hyprland = hyprland.mkExtraLib { inherit lib; };

      nixvim = nixvim.mkExtraLib { inherit lib; };

      sops = sops.mkExtraLib { inherit lib; };

      tmux = tmux.mkExtraLib { inherit lib; };

      mkHomeContext =
        {
          pkgs,
          username,
          osConfig ? null,
        }:
        let
          standalone = osConfig == null || builtins.attrNames osConfig == [ ];
          config = if standalone then { } else osConfig;

          homeDirectory = lib.attrByPath [ "users" "users" username "home" ] "/${
            if pkgs.stdenv.isDarwin then "Users" else "home"
          }/${username}" config;

          desktop =
            pkgs.stdenv.isLinux
            && lib.attrByPath [
              "programs"
              "hyprland"
              "enable"
            ] false config;
        in
        {
          inherit
            username
            standalone
            homeDirectory
            desktop
            ;
        };

      mkImports =
        {
          dirs,
          recursive ? true,
          excludeDefault ? false,
        }:
        let
          scan =
            dir:
            let
              entries = builtins.readDir dir;

              files = lib.filterAttrs (
                name: type:
                type == "regular" && lib.hasSuffix ".nix" name && (!excludeDefault || name != "default.nix")
              ) entries;

              subdirs = lib.filterAttrs (_: type: type == "directory") entries;
            in
            (lib.mapAttrsToList (name: _: import "${dir}/${name}") files)
            ++ lib.optionals recursive (lib.concatMap (name: scan "${dir}/${name}") (lib.attrNames subdirs));
        in
        lib.concatMap scan dirs;
    };
}
