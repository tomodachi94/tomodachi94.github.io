{
  description = "A flake for building my Hugo website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
	tomopkgs = {
	  url = "github:tomodachi94/dotfiles?dir=pkgs";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { nixpkgs, tomopkgs, ... }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
		"x86_64-darwin"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: {
	  default = pkgs.stdenvNoCC.mkDerivation rec {
        name = "hugo-website";
        src = ./.;
        nativeBuildInputs = [ pkgs.hugo tomopkgs.packages.${pkgs.system}.hugo-bearblog ];
        buildPhase = "hugo --minify";
        configurePhase = ''
		  rm -rf ./themes
          mkdir ./themes
          ln -s ${tomopkgs.packages.${pkgs.system}.hugo-bearblog} ./themes/hugo-bearblog
        '';
        installPhase = "mv public $out";
      };
    });
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = with pkgs; [ hugo lychee ];
		shellHook = ''
		  rm -rf ./themes
		  mkdir -p ./themes
          ln -s ${tomopkgs.packages.${pkgs.system}.hugo-bearblog}/ ./themes/hugo-bearblog
		'';
	  };
	});
  };
}
