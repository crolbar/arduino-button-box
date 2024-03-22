{
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            cargo-binutils
            pkg-config
            dfu-util
            (rust-bin.stable.latest.default.override {
              targets = [ "thumbv7m-none-eabi" ];
              extensions = [ "rust-src" "llvm-tools-preview" ];
            })
          ];
        };
      }
    );
}
