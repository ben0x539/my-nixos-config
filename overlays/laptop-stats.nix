{ pkgs' ? import <nixpkgs> {} }:

let
  mozilla = pkgs'.fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "661f3f4d8183f493252faaa4e7bf192abcf5d927";
    sha256 = "0g1ig96a5qzppbf75qwll8jvc7af596ribhymzs4pbws5zh7mp6p";
  };
  pkgs = import <nixpkgs> {
    overlays = [
      (import "${mozilla}/rust-overlay.nix")
    ];
  };
  rustNightly = pkgs.rustChannelOf {
    date = "2018-06-01";
    channel = "nightly";
  };

  buildRustCrate = pkgs.callPackage <nixpkgs/pkgs/build-support/rust/build-rust-crate> {
    rustc = rustNightly.rust;
  };

  laptop-stats-src = pkgs.fetchFromGitHub {
    owner = "ben0x539";
    repo = "laptop-stats";
    rev = "3cf79df44e825a85112c56e84735f209878f6502";
    sha256 = "02k36q91447p0fgy9fkqbkycs86c2highps8drdc1fkwzx2nhk8r";
  };

  crates = pkgs.callPackage "${laptop-stats-src}/Cargo.nix" {
    inherit buildRustCrate;
  };

in

crates.laptop_stats_0_1_0 {}
