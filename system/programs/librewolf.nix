{
  config,
  user,
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = config.home-manager.users.${user}.my.pkgs.apps.enable;
    package = pkgs.librewolf;

    preferencesStatus = "locked"; # reset preferences on each startup

    # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
    # ---- POLICIES ----
    # Check about:policies#documentation for options.
    policies = {
      DefaultDownloadDirectory = "\${home}/downloads/"; # Set the default download directory
      DownloadDirectory = "\${home}/downloads/"; # Set and lock the download directory
      SearchEngines = {
        Default = "DuckDuckGo";
        PreventInstalls = true;
        Add = [
          {
            Name = "Nix_Packages";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            Method = "GET";
            IconURL = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
            Alias = "!np";
          }
          {
            Name = "Nix_Options";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
            Method = "GET";
            IconURL = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
            Alias = "!no";
          }
          {
            Name = "Nix_Functions";
            URLTemplate = "https://noogle.dev/q/?term={searchTerms}";
            Method = "GET";
            IconURL = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
            Alias = "!nf";
          }
          {
            Name = "Wikipedia";
            URLTemplate = "https://en.wikipedia.org/w/index.php?search={searchTerms}";
            Method = "GET";
            IconURL = "https://en.wikipedia.org/static/favicon/wikipedia.ico";
            Alias = "!w";
          }
          {
            Name = "Youtube";
            URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
            Method = "GET";
            IconURL = "https://www.youtube.com/s/desktop/adccb25c/img/favicon.ico";
            Alias = "!y";
          }
        ];
        Remove = [
          "Bing"
          "Google"
          "Perplexity"
          "Qwant"
          "Startpage"
          "Wikipedia (en)"
          "Mojeek"
        ];
      };
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        FormData = true;
        Sessions = false;
        SiteSettings = true;
        Exceptions = [
          "https://www.youtube.com"
          "https://www.netflix.com"
          "https://www.deezer.com"
          "https://github.com"
          "https://discord.com"
        ];
        Locked = true; # prevents user from changing manualy
      };

      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings =
        let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in
        {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          "{3b84c123-55bd-4a5f-b681-75c40be99dbc}" = {
            install_url = moz "windows-95-browser";
            installation_mode = "force_installed";
          };
          "uBlock0@raymondhill.net" = {
            install_url = moz "ublock-origin";
            installation_mode = "force_installed";
          };
          "CanvasBlocker@kkapsner.de" = {
            install_url = moz "canvasblocker";
            installation_mode = "force_installed";
          };
          "sponsorBlocker@ajay.app" = {
            install_url = moz "sponsorblock";
            installation_mode = "force_installed";
          };
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            install_url = moz "return-youtube-dislikes";
            installation_mode = "force_installed";
          };
          "myallychou@gmail.com" = {
            install_url = moz "youtube-recommended-videos";
            installation_mode = "force_installed";
          };
          "tridactyl.vim@cmcaine.co.uk" = {
            install_url = moz "tridactyl-vim";
            installation_mode = "force_installed";
          };
        };
    };

    # ---- PREFERENCES ----
    # Check about:config for options.
    preferences = {
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "browser.search.suggest.enabled" = true;
    };

    # find syntax examples : find / -type f -name "mozilla.cfg"
    # TODO: remove later firefox sync with bitwarden
    autoConfig = ''
      // middle mouse scroll "autoscroll"
      pref("middlemouse.paste", false);
      pref("general.autoScroll", true);

      // keep resistFingerprinting while having darkmode work
      pref("privacy.resistFingerprinting", false);
      pref("privacy.fingerprintingProtection", true);
      pref(
        "privacy.fingerprintingProtection.overrides",
        "+AllTargets,-CSSPrefersColorScheme"
      );

      // enable firefox sync
      defaultPref("identity.fxaccounts.enabled", true);
    '';
  };

  environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
}
