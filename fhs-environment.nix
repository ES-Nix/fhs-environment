{ pkgs ? import <nixpkgs> { } }:
let
  fhs = pkgs.buildFHSUserEnv {
    name = "enter-fhs";
    targetPkgs = pkgs: with pkgs;
      [
        atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        gdb
        git
        gnome2.GConf
        gnome2.gdk_pixbuf
        gnome2.gtk
        gnome2.pango

        alsaLib
        glib
        libnotify
        libxml2
        libxslt

        nixFlakes
        netcat
        nspr
        nss
    #    oraclejdk8
        file
        strace
        watch
        wget
        which
        zlib

        udev

        xorg.libX11
        xorg.libXScrnSaver
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
        xorg.xcbutilkeysyms

        zsh
      ];

    multiPkgs = pkgs: with pkgs; [
                                  zlib
                                 ];

    runScript = "$SHELL";

    #echo $TEST_EXPORT
    profile = ''
      export TEST_EXPORT='123abc'
    '';

  };

  scriptExample = pkgs.writeShellScriptBin "script-example" ''
    #!${pkgs.runtimeShell}
      echo 'A bash script example!'
  '';

in
pkgs.stdenv.mkDerivation {
  name = "fhs-env-derivation";

  # https://nix.dev/anti-patterns/language.html#reproducability-referencing-top-level-directory-with
  src = builtins.path { path = ./.; };

  nativeBuildInputs = [ fhs ];

  installPhase = ''
    mkdir --parent $out
    cp -r ${fhs}/bin/enter-fhs $out/enter-fhs
    cp -r ${scriptExample}/bin/script-example $out/script-example
  '';
}
