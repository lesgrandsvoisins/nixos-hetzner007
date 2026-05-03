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
    ./custom/filebrowser.nix
    ./custom/ghostio.nix
    ./custom/guichet.nix
    ./custom/gv-ldap-update.nix
    ./custom/linkding.nix
    ./custom/odoo.nix
    ./custom/tmpfiles.nix
    ./custom/wagtail.nix
  ];
}
