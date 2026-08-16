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

      isStandalone = cfg: cfg == null || builtins.attrNames cfg == [ ];

      getHomeDir =
        {
          pkgs,
          username,
          osConfig ? { },
        }:
        let
          nixosHome = lib.attrByPath [ "users" "users" username "home" ] null osConfig;
          defaultHome = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";
        in
        if nixosHome != null then nixosHome else defaultHome;

      joinPipe = parts: lib.concatStringsSep " | " (map lib.strings.trim parts);

      mkJq =
        {
          args ? [ ],
          query ? ".",
        }:
        "jq ${lib.concatStringsSep " " args} '${lib.strings.trim query}'";

      importModules =
        {
          dir,
          args ? { },
          recursive ? false,
          excludeDefault ? true,
        }:
        let
          isNixFile =
            name: type:
            type == "regular" && lib.hasSuffix ".nix" name && (!excludeDefault || name != "default.nix");

          readDir =
            dir:
            let
              entries = builtins.readDir dir;

              files = lib.filterAttrs isNixFile entries;

              dirs = lib.filterAttrs (_: type: type == "directory") entries;
            in
            (lib.mapAttrsToList (name: _: import (dir + "/${name}") args) files)
            ++ lib.optionals recursive (lib.concatMap (name: readDir (dir + "/${name}")) (lib.attrNames dirs));
        in
        readDir dir;
    };
}
