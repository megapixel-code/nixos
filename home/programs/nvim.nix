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
}
