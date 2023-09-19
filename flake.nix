{
  inputs.pinned-nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, pinned-nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
      	pkgs = import nixpkgs {
        	inherit system;
        	config = {
        	  	allowBroken = true;
        	};
      	};

        pinned-pkgs = pinned-nixpkgs.legacyPackages.${system};
        erlpkgs = pinned-pkgs.beam.packages.erlangR23;
        node = pkgs.nodejs-16_x;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with erlpkgs; [
            pkgs.act
            rebar3
            erlang
          ];
        };
      }
    );
}


