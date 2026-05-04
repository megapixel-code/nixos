{
  pkgs,
  user,
  lib,
  config,
  ...
}:
{
  options = {
    nvim.extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = lib.mkIf config.home-manager.users.${user}.my.pkgs.utilities.system.enable {
    environment.systemPackages =
      let
        extraWrapperArgs = [
          "--suffix"
          "PATH"
          ":"
          (lib.makeBinPath config.nvim.extraPackages)
        ];
      in
      [
        (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
          wrapperArgs = extraWrapperArgs;
          wrapRc = false;
        })
      ];

    nvim.extraPackages = with pkgs; [
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
      # pascal-language-server # pascal TODO:
      metals # scala
      nil # nix
      nixd # nix

      tinymist # typst
      neocmakelsp # cmake
      superhtml # html
      vscode-css-languageserver # css
      vscode-json-languageserver # json/jsonc
      yaml-language-server # yaml

      # formatters
      shfmt # bash
      prettierd # css, and more but just css for now
      typstyle # typst
      nixfmt # nix
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
      tinymist # typstpreview
      websocat # typstpreview
      tree-sitter # tree-sitter
    ];
  };
}
