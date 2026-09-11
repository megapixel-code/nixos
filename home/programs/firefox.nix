{
  config,
  ...
}:
{
  programs.firefox = {
    enable = config.my.pkgs.apps.enable;

    configPath = "${config.xdg.configHome}/mozilla/firefox";

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
            Name = "Nix_Search";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            Method = "GET";
            IconURL = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
            Alias = "!n";
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
        ];
      };

      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # windows 95 Browser Theme :
        "{3b84c123-55bd-4a5f-b681-75c40be99dbc}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3755529/windows_95_browser-1.0.xpi";
          installation_mode = "force_installed";
        };
      };
      # ---- PREFERENCES ----
      # Check about:config for options.
      Preferences = {
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
}
