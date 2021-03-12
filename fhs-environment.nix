{ pkgs ? import <nixpkgs> {} }:

let
  fhs = pkgs.buildFHSUserEnv {
    name = "fhs-env";
    targetPkgs = pkgs: with pkgs;
      [ 
      hello 
      ];

    multiPkgs = pkgs: with pkgs;
      [ zlib ];
    runScript = "bash";
  };

  scriptExample = pkgs.writeShellScriptBin "script-example" ''
    #!${pkgs.runtimeShell}
      echo 'A bash script example!'
  '';

in pkgs.stdenv.mkDerivation {
  name = "fhs-env-derivation";

  # https://nix.dev/anti-patterns/language.html#reproducability-referencing-top-level-directory-with
  src = builtins.path { path = ./.; };

  nativeBuildInputs = [ fhs ];

  installPhase = ''
    mkdir --parent $out
    cp -r ${fhs}/bin/fhs-env $out/fhs-env
    cp -r ${scriptExample}/bin/script-example $out/script-example
  '';
}
