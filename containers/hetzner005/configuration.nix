{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      ./common.nix
      ./services.nix
    ];
  }
