{ pkgs ? import <nixpkgs> { } }:
let
  fhs = pkgs.buildFHSUserEnv {
    name = "fhs-env";

  targetPkgs = pkgs: (with pkgs; let
    sh = (pkgs.runCommand "sh" {} ''
      mkdir --parent $out/bin
      cat > $out/bin/bash <<'EOF'
        #!${bashInteractive}/bin/bash
          export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
          export LOCALEARCHIVE=/usr/lib/locale/locale-archive
          exec -a /bin/bash ${bashInteractive}/bin/bash "$@"
      EOF
      chmod +x $out/bin/bash
      ln --symbolic $out/bin/bash $out/bin/sh
    '');
    in [
        coreutils
        gcc
        glibc
        glibcLocales
        hello
        which
        file
    (pkgs.runCommand "python3" {} ''
      mkdir --parent $out/bin
      cat > $out/bin/python3 <<'EOF'
        #!${runtimeShell}
          export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
          export LOCALEARCHIVE=/usr/lib/locale/locale-archive
          exec -a /usr/bin/python3 ${python3}/bin/python "$@"
      EOF
      chmod +x $out/bin/python3
    '')
    (pkgs.runCommand "tests_locale_with_python" {} ''
      mkdir --parent $out/bin
      cat > $out/bin/tests_locale_with_python <<'EOF'
      #!${runtimeShell}
        echo 'Running test of python and locale with pt_BR.UTF-8'

        echo $(readlink $(which python3))
        echo '.'

        python3 -c 'import locale; locale.setlocale(locale.LC_ALL, "pt_BR.UTF-8")'
        echo '.'

        file $(echo $(readlink --canonicalize $(echo $LOCALE_ARCHIVE)))
        echo '.'
      EOF
      chmod +x $out/bin/tests_locale_with_python
    '')
  ]);
    runScript = "bash";
  };
in
pkgs.stdenv.mkDerivation {
  name = "fhs-env-derivation";

  # https://nix.dev/anti-patterns/language.html#reproducability-referencing-top-level-directory-with
  src = builtins.path { path = ./.; };

  nativeBuildInputs = [ fhs ];

  installPhase = ''
    mkdir --parent $out/bin
    cp -r ${fhs}/bin/fhs-env $out/bin/fhs-env
  '';
}
