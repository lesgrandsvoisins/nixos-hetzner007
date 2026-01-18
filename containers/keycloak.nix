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

  systemd.tmpfiles.rules = [
    "d /etc/keycloak/certs 0660 root root"
  ];
  containers.keycloak = {
    bindMounts = {
      "/etc/keycloak/" = {
        hostPath = "/etc/keycloak/";
        isReadOnly = true;
      };
    };
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.105.10";
    localAddress = "192.168.105.11";
    # hostAddress6 = "fa01::1";
    # localAddress6 = "fa01::2";
    hostAddress6 = "2a01:4f8:241:4faa::10";
    localAddress6 = "2a01:4f8:241:4faa::11";
    config = {
      system.stateVersion = "25.11";
      nix.settings.experimental-features = "nix-command flakes";
      imports = [
        ../modules/packages/common.nix
        ../modules/packages/vim.nix
      ];
      networking = {
        hostName = "keycloak";
        domain = "keycloak.grandsvoisins.org";
        hosts = {
          "2a01:4f8:241:4faa::11" = [ "keycloak.local" ];
        };
        useHostResolvConf = false;
        interfaces."eth0".useDHCP = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            80
            443
            587
            5432
            14443
          ];
        };
        interfaces.eth0 = {
          ipv6 = {
            addresses = [
              {
                address = (builtins.elemAt vars.hetzner.ipv6 9).addr;
                prefixLength = (builtins.elemAt vars.hetzner.ipv6 9).netmask;
              }
            ];
          };
        };
      };
      systemd.tmpfiles.rules = [
        "d /etc/keycloak/certs 0660 root root"
      ];
      users.users.keycloak = {
        uid = vars.uid.keycloak;
        group = "services";
        isSystemUser = true;
      };
      users.groups.services.gid = vars.gid.services;

      services = {
        resolved = {
          enable = true;
        };
        keycloak = {
          enable = true;
          database = {
            username = "key";
            passwordFile = "/etc/keycloak/.dbpassword";
            host = "localhost";
          };
          settings = {
            # https-port = 14443;
            # http-port = 14080;
            proxy-headers = "xforwarded";
            hostname = "keycloak.grandsvoisins.org";
          };
          sslCertificate = "/etc/keycloak/certs/keycloak.local.pem";
          sslCertificateKey = "/etc/keycloak/certs/keycloak.local-key.pem";
        };
      };
    };
  };
}
