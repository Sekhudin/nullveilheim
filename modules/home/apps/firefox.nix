{
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.firefox;
  stateVersion = config.home.stateVersion;
  urls = {
    github = "https://github.com/";
    home-manager = "https://home-manager.dev/manual/${stateVersion}/options.xhtml";
    linkedin = "https://www.linkedin.com/";
    mdn = "https://developer.mozilla.org/";
    nixos = "https://nixos.org/learn/";
    nixos-options = "https://search.nixos.org/options?channel=${stateVersion}";
    nixos-pkgs = "https://search.nixos.org/packages?channel=${stateVersion}";
  };

  fox = {
    markAs = name: url: {
      inherit
        name
        url
        ;
    };

    pinAs = title: url: {
      inherit
        title
        url
        ;
    };

    mkEngine = p: {
      name = p.name;
      definedAliases = p.aliases;
      urls = map (url: {
        template = "${url}{searchTerms}";
      }) p.urls;
    };
  };
in
{
  options.homeApps.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable firefox";
      default = true;
    };
  };

  config.programs.firefox = {
    enable = cfg.enable;
    policies = {
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      RequestedLocales = [ "en-US" ];
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };

        "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };

  config.programs.firefox.profiles.personal = {
    id = 0;
    isDefault = true;
    bookmarks = {
      force = true;
      settings = [
        (fox.markAs "GitHub" urls.github)
        (fox.markAs "LinkedIn" urls.linkedin)
        (fox.markAs "NixOS" urls.nixos)
        "separator"
        {
          name = "Development";
          toolbar = true;
          bookmarks = [
            (fox.markAs "MDN" urls.mdn)
            (fox.markAs "Home Manager" urls.home-manager)
            (fox.markAs "NixOS Options" urls.nixos-options)
            (fox.markAs "NixOS Packages" urls.nixos-pkgs)
          ];
        }
      ];
    };
    search = {
      force = true;
      default = "google";
      privateDefault = "ddg";
      order = [
        "google"
        "ddg"
        "home-manager"
        "nixos-option"
        "nixos-pkg"
      ];
      engines = {
        home-manager = fox.mkEngine {
          name = "Home Manager";
          urls = [ "${urls.home-manager}#opt-" ];
          aliases = [
            "@hm"
          ];
        };
        nixos-option = fox.mkEngine {
          name = "NixOS Options";
          urls = [ "${urls.nixos-options}&query=" ];
          aliases = [
            "@nixos"
          ];
        };
        nixos-pkg = fox.mkEngine {
          name = "NixOS Packages";
          urls = [ "${urls.nixos-pkgs}&query=" ];
          aliases = [
            "@pkg"
          ];
        };
      };
    };
    settings = {
      "browser.theme.content-theme" = 0;
      "browser.theme.toolbar-theme" = 0;
      "browser.bookmarks.showMobileBookmarks" = true;
      "browser.newtabpage.pinned" = [
        (fox.pinAs "GitHub" urls.github)
        (fox.pinAs "LinkedIn" urls.linkedin)
      ];
    };
  };
}
