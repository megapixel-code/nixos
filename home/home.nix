{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./formatters.nix
    ./cursor.nix
  ];

  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";

    # packages = with pkgs; [
    #   # inputs.quickshell.packages."${pkgs.system}".default # bar
    # ];

    activation = {
      create-screenshoot-folder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $GRIM_DEFAULT_DIR
      ''; # $HOME/images/screenshoots/
      create-documents-folder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/documents/projects/
      ''; # $HOME/documents/
    };
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      git
      gnumake
      cmake
      gcc
      curl
      unzip
      gnutar # tar
      gcc
      wl-clipboard
      fzf
      ripgrep

      # nvim lsp
      nodejs
      jdk
      jre
      shellcheck
      typst

      # language servers
      lua-language-server # lua
      pyrefly # python
      jdt-language-server # java

      clang-tools # c cpp
      bash-language-server # bash

      vscode-json-languageserver # json/jsonc
      vscode-css-languageserver # css
      superhtml # html
      tinymist # typst
      nil # nix
      nixd # nix

      # formatters
      shfmt # bash

      prettierd # css, and more but just css for now
      typstyle # typst
      nixfmt-rfc-style # nix

      # DAP
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test
    ];
  };

  programs.firefox = {
    enable = true;

    # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
    # ---- POLICIES ----
    # Check about:policies#documentation for options.
    policies = {
      DefaultDownloadDirectory = "\${home}/downloads/"; # Set the default download directory
      DownloadDirectory = "\${home}/downloads/"; # Set and lock the download directory

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
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Megapixel-code";
      user.email = "chainemegapixel@gmail.com";
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
