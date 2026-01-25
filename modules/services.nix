{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
in
{
  # Enable the OpenSSH daemon.
  imports = [
    ./services/lldap.nix
    ./services/caddy.nix
    ./services/postgresql.nix
    ./services/wiki-js.nix
    ./services/radicale.nix
  ];
  # systemd.tmpfiles.rules = [
  #   "d /etc/pocket-id 0775 pocket-id services"
  #   "f /etc/pocket-id/pocket-id.env 0664 pocket-id services"
  #   "f /etc/pocket-id/.encryption_key 0664 pocket-id services"
  # ];
  services = {
    xandikos = {
      enable = true;
      port = vars.ports.xandikos;
      extraOptions = [
        "--autocreate"
        "--defaults"
        "--current-user-principal user"
        "--dump-dav-xml"
      ];
    };
    openssh = {
      enable = true;
      listenAddresses = [
        {
          addr = "[::]";
          port = 22;
        }
        {
          addr = "0.0.0.0";
          port = 22;
        }
      ];
    };
    redis.servers.homarr = {
      enable = true;
      port = vars.ports.redis-services-homarr;
    };
    # forgejo = {
    #   enable = true;
    #   HTTP_PORT = 3003;
    #   HTTP_ADDR = "0.0.0.0";
    # };
    # pocket-id = {
    #   enable = true;
    #   settings = {
    #     APP_URL = "http://localhost:1411";
    #     ENCRYPTION_KEY_FILE = "/etc/pocket-id/.encryption_key";
    #     TRUST_PROXY = "true";
    #     UPLOAD_PATH = "/var/lib/pocket-id"
    #   };
    # };
    #     acme-dns = {
    #       enable = true;
    #       settings = {
    #
    #       };
    #     };
    #     nginx = {
    #       enable = true;
    #       virtualHosts = {
    #         "hetzner007.gdvoisins.com" = {
    #           forceSSL = true;
    #           enableACME = true;
    #         };
    #       };
    #     };
  };
}
