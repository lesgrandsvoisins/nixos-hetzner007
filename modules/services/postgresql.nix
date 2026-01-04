{
  pkgs,
  lib,
  config,
  ...
}: let
  vars = import ../../vars.nix;
in {
  services.postgresql = {
    enable = true;

    # enableTCPIP = true;
    # listen_addresses = "2a01:4f8:241:4faa::10";
    enableTCPIP = false;
    settings = {
      # ssl = true;
      # ssl_key_file = "/var/lib/acme/www.configmagic.com/key.pem";
      # ssl_cert_file = "/var/lib/acme/www.configmagic.com/fullchain.pem";
      port = vars.ports.postgresql;
      # listen_addresses = lib.mkForce "2a01:4f8:241:4faa::";
    };
  };
}
