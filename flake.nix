{
  description = "This is a nix flake buildFHSUserEnv environment";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsAllowUnfree = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
      in
      {
        packages.fhs-environment = import ./fhs-environment.nix {
          pkgs = pkgsAllowUnfree;
        };

        defaultPackage = import ./fhs-environment.nix {
          pkgs = pkgsAllowUnfree;
        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            self.defaultPackage.${system}
            self.packages.${system}.fhs-environment
          ];
          shellHook = ''
            echo "Entering the nix devShell"

            export PATH=${self.packages.${system}.fhs-environment}:$PATH

            # Just as example script
            script-example
            exec enter-fhs

          '';
        };
      });
}
