{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    owner = "Gissio";
    repo = "font_Tiny5";
  in
  {
    pname = "Tiny5";
    version = "2.007";

    src = fetchFromGitHub {
      owner = owner;
      repo = repo;
      tag = finalAttrs.version;
      hash = "sha256-v6fy9gMK0oc5j6ZO6YXPeSP4mMdxwI4JJ7XVS1u9oms=";
    };

    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/share/fonts/bdf"
      mkdir -p "$out/share/fonts/opentype"
      mkdir -p "$out/share/fonts/truetype"

      mv fonts/bdf/*.bdf "$out/share/fonts/bdf"
      mv fonts/otf/*.otf "$out/share/fonts/opentype"
      mv fonts/ttf/*.ttf "$out/share/fonts/truetype"
    '';

    __structuredAttrs = true;
    strictDeps = true;

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "A 5-pixel monospace variable font that captures the essence of 1980s–90s digital minimalism.";
      homepage = "https://github.com/${owner}/${repo}";
      license = lib.licenses.ofl;
      maintainers = with lib.maintainers; [ megapixel-code ];
      platforms = with lib.platforms; unix;
      mainProgram = "${finalAttrs.pname}";
    };
  }
)
