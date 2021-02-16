{ pkgs ? import <nixpkgs> {} }:

let 

  fhs = pkgs.buildFHSUserEnv {
    name = "fsh-env";
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

  src = ./.;

  nativeBuildInputs = [ fhs ];

 installPhase = ''
   mkdir --parent $out
   ln -sf ${fhs}/bin/fsh-env $out/fsh-env
   cp -r ${scriptExample}/bin/script-example $out/script-example
 '';

  shellHook = ''
    exec ${fhs}/bin/fsh-env
  '';
}

