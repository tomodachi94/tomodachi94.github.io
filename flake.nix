{
  description = "A flake for building my Hugo website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
	hugo-bearblog = {
      url = "github:janraasch/hugo-bearblog";
	  flake = false;
	};
  };

  outputs = { nixpkgs, hugo-bearblog, ... }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
		"x86_64-darwin"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});
  in rec {
    packages = forAllSystems (pkgs: {
	  default = pkgs.stdenvNoCC.mkDerivation rec {
        name = "hugo-website";
        src = ./.;
        nativeBuildInputs = [ pkgs.hugo ];
        buildPhase = "hugo --minify";
        configurePhase = ''
		  rm -rf ./themes
          mkdir ./themes
          ln -s ${hugo-bearblog} ./themes/hugo-bearblog
        '';
        installPhase = "mv public $out";
      };
    });
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages = with pkgs; [ just lychee ];
		inputsFrom = [ packages.${pkgs.system}.default ];
		shellHook = ''
		  rm -rf ./themes
		  mkdir -p ./themes
          ln -s ${hugo-bearblog} ./themes/hugo-bearblog
		'';
	  };
	});
  };
}
