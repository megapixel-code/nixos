{
  pkgs,
  ...
}:
{
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty; # used to read passwords
  };
}
