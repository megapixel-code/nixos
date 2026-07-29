{
  inputs,
  system,
  user,
  ...
}:
let
  nixpkgs = inputs.nixpkgs;
  lib = nixpkgs.lib;
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  makeWrapper =
    {
      package,
      package_exec,
      script ? "",
      extra_flags ? "",
    }:
    pkgs.symlinkJoin {
      name = package;
      paths = [
        (pkgs.writers.writeBashBin package_exec (
          script
          + ''
            exec ${package}/bin/${package_exec} ${extra_flags} "$@"
          ''
        ))
        package
      ];
    };
}
