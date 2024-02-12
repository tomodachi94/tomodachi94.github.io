{
  description = "A flake for building my Hugo website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, devenv, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.hugo-bearblog = pkgs.stdenv.mkDerivation rec {
          pname = "hugo-bearblog";
          version = "2024-01-23";
          src = pkgs.fetchFromGitHub {
            owner = "janraasch";
            repo = "hugo-bearblog";
            rev = "0b64d5ad103c716da5a79b48855f1489f6738ba7";
            hash = "sha256-cyMWdCIZJV6zyIEgg3jbPV1BfDO4eRUY8pP6PmDfY6Y=";
          };
          phases = [ "installPhase" ];
          installPhase = ''
            mkdir $out
            cp $src/theme.toml $out
            cp -r $src/layouts $out
            cp -r $src/archetypes $out
          '';
        };
        packages.hugo-website = pkgs.stdenv.mkDerivation rec {
          pname = "hugo-website";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.hugo self.packages.${system}.hugo-bearblog ];
          buildPhase = "hugo";
          configurePhase = "cp -r ${self.packages.${system}.hugo-bearblog} ./themes/hugo-bearblog";
          installPhase = "mv public $out";
        };
        defaultPackage = self.packages.${system}.hugo-website;
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.hugo ];
          inherit inputs pkgs;
          modules = [
            ({ pkgs, ... }: {
              # This is your devenv configuration
              packages = [ pkgs.hugo ];
              processes.run.exec = "hugo serve";
            })
          ];
        };
      });
}

