{
  description = "postamt development environment (Rails 5.2, Ruby 2.7)";

  # nixos-22.11 is pinned because current nixpkgs has dropped Ruby 2.x.
  # Rails 5.2 is incompatible with Ruby 3.0+ (keyword argument breaking changes).
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            ruby_2_7
            postgresql
          ];

          shellHook = ''
            export GEM_HOME=$PWD/.gems
            export GEM_PATH=$GEM_HOME
            export PATH=$GEM_HOME/bin:$PATH
          '';
        };
      }
    );
}
