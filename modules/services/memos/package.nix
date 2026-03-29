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
  version = "0.0.2-gv1";

  meta.mainProgram = "memos";

  src = fetchFromGitHub {
    owner = "chris2fr";
    repo = "memos";
    rev = "main";
    hash = "sha256-eWDTR9j4kSmBiMxaWp0ZgsLEjd3QPAjoR8MXtQ9J/eU=";
  };

  buildInputs = [
    go_1_26
  ];

  vendorHash = "sha256-e5KGQv80ky2tDW4nqC3aZuc9AWTfiNiYlaBf++IgCO4=";
}
