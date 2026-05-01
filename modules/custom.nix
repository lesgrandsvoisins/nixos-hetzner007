{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  imports = [
    ./custom/apostrophecms.nix
    ./custom/ghostio.nix
    ./custom/odoo.nix
    ./custom/guichet.nix
  ];
}
