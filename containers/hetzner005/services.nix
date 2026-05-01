{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  imports = [
    ./services/bind.nix
    ./services/homepage-dashboard.nix
    ./services/radicale.nix
    ./services/sftpgo.nix
    ./services/vaultwarden.nix
    ./services/vikunja.nix
  ];
}
