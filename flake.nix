{
  description = "This is a nix flake podman rootless package";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgsAllowUnfree = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };

      in
      {

        packages.fhs-environment = import ./fhs-environment.nix {
          pkgs = pkgs;
        };

        defaultPackage = import ./fhs-environment.nix {
          pkgs = pkgs;
        };

        devShell = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            neovim
            self.defaultPackage.${system}
            self.packages.${system}.fhs-environment
          ];
          shellHook = ''
            echo "Entering the nix devShell"
            script-exemple
            
            #podman-setup-script
            #podman-capabilities
          '';
        };
      });
}
