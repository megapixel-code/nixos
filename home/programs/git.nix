{
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Megapixel-code";
      user.email = "chainemegapixel@gmail.com";
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };
}
