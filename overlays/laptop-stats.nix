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
    date = "2018-01-09";
    channel = "nightly";
  };

  buildRustCrate = pkgs.callPackage <nixpkgs/pkgs/build-support/rust/build-rust-crate.nix> {
    rustc = rustNightly.rust;
  };

  laptop-stats-src = pkgs.fetchFromGitHub {
    owner = "ben0x539";
    repo = "laptop-stats";
    rev = "9c5744134936cacd2da22dd53b723bb3656214c5";
    sha256 = "1vkw9svygmdjb1jkg25538b83s57lzplisxnf72c1nghp22iz7bw";
  };

  crates = pkgs.callPackage "${laptop-stats-src}/crates.nix" {
    inherit buildRustCrate;
  };

in

crates.laptop_stats_0_1_0 {}
