{
  config,
  pkgs,
  inputs,
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
      nixfmt-rfc-style # nix
    ];
  };

  programs.firefox.enable = true;

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
