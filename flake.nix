{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = self.packages.symdig;
        packages.symdig = pkgs.stdenv.mkDerivation {
          name = "symdig";
          src = self;
          buildInputs = with pkgs; [nushell];
          installPhase = ''
            mkdir -p $out/bin
            cp ./symdig.nu $out/bin/symdig
            chmod +x $out/bin/symdig
          '';
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nushell
            self.packages.${system}.symdig
          ];
        };
      }
    );
}
