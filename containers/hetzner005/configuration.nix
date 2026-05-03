{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ./vars.nix;
in {
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./common.nix
    ./custom.nix
    ./services.nix
    ./security.nix
    ./home-manager.nix
    ./mailserver.nix
    ./users.nix
    # ./secrets.nix
  ];
  system.stateVersion = "25.11";
  users.groups.services.gid = vars.gid.services;
  users.users.vikunja.uid = vars.uid.vikunja;
  nixpkgs.config.permittedInsecurePackages = [
    "sope-5.11.2"
    "python3.13-pypdf2-3.0.1"
    "python3.11-pypdf2-3.0.1"
    "python3.15-pypdf2-3.0.1"
  ];

  environment.systemPackages = with pkgs; [
    yarn
    filebrowser
    cacert
    # burp
    openssl
    acme-sh
    acme-client
    certbot
    # postgresql_14
    qemu
    # (pkgs.callPackage ./etc/sftpgo/sftpgo/default.nix { }  )
    (pkgs.callPackage ./etc/sftpgo/sftpgo-plugin-auth/sftpgoPluginAuth.nix {})
  ];
}
