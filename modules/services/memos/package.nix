{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  stdenv ? pkgs.stdenv,
  fetchurl ? pkgs.fetchurl,
  autoPatchelfHook ? pkgs.autoPatchelfHook,
  makeWrapper ? pkgs.makeWrapper,
  glibc ? pkgs.glibc,
  go_1_26 ? pkgs.go_1_26,
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  buildGoModule ? pkgs.buildGoModule,
  ...
}:
buildGoModule rec {
  pname = "memos";
  version = "gv0.25.3";

  meta.mainProgram = "memos";

  src = fetchFromGitHub {
    owner = "lesgrandsvoisins";
    repo = "memos";
    rev = "gv0.25.3";
    hash = "sha256-yWWcNOpMmcEfOiUdQcixpg9nNmFJ5BvNqkTLOZ+0LGg=";
  };

  buildInputs = [
    go_1_26
  ];

  vendorHash = "sha256-BoJxFpfKS/LByvK4AlTNc4gA/aNIvgLzoFOgyal+aF8=";
}
