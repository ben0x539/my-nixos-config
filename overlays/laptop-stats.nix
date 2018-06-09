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

  buildRustCrate = pkgs.callPackage <nixpkgs/pkgs/build-support/rust/build-rust-crate.nix> {
    rustc = rustNightly.rust;
  };

  laptop-stats-src = pkgs.fetchFromGitHub {
    owner = "ben0x539";
    repo = "laptop-stats";
    rev = "1b4267d7df700eae2ff0d5308966a01fc734fc56";
    sha256 = "0r6vjd9phl6frf3qcz67bmfzsm53ln38lfc7z23ch7gv6zdmzvvg";
  };

  crates = pkgs.callPackage "${laptop-stats-src}/crates.nix" {
    inherit buildRustCrate;
  };

in

crates.laptop_stats_0_1_0 {}
