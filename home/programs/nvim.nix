{
  pkgs,
  ...
}:
{
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

      # language servers
      nodejs
      jdk
      jre
      jdt-language-server # java
      lua-language-server # lua
      pyrefly # python
      clang-tools # c cpp
      bash-language-server # bash
      metals # scala
      nil # nix
      nixd # nix

      tinymist # typst
      neocmakelsp # cmake
      superhtml # html
      vscode-json-languageserver # json/jsonc
      vscode-css-languageserver # css

      # formatters
      shfmt # bash
      prettierd # css, and more but just css for now
      typstyle # typst
      nixfmt-rfc-style # nix
      mbake # make
      pasfmt # pascal / delphi
      shellcheck # bash

      # DAP
      vscode-extensions.vscjava.vscode-java-debug
      vscode-extensions.vscjava.vscode-java-test

      # plugins
      nodejs # Markdown Preview
      yarn # Markdown Preview
      typst # preview and compile
    ];
  };
}
