{
  description = "A flake for building my Hugo website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    devenv.url = "github:cachix/devenv";
	devenv.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
	tomodachi94.url = "github:tomodachi94/dotfiles?dir=pkgs";
	tomodachi94.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, devenv, flake-utils, tomodachi94, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
		tomopkgs = tomodachi94.packages.${system};
      in
      {
        packages.hugo-website = pkgs.stdenv.mkDerivation rec {
          pname = "hugo-website";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.hugo tomopkgs.hugo-bearblog ];
          buildPhase = "hugo --minify";
          configurePhase = ''
            mkdir ./themes
            cp -r ${tomopkgs.hugo-bearblog} ./themes/hugo-bearblog
          '';
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

