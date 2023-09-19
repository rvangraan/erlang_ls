{
  inputs.pinned-nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, pinned-nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pinned-pkgs = pinned-nixpkgs.legacyPackages.${system};
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = with pinned-pkgs.beam.packages.erlangR22; [
            erlang
            rebar3
            erlang-ls
          ];
        };
      }
    );
}
