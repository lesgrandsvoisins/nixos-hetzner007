{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # caddy-ui-lesgrandsvoisins = pkgs.callPackage ./derivations/caddy-ui-lesgrandsvoisins.nix {};
  # vars = ../../vars.nix;
in {
  systemd.tmpfiles.rules = [
    "d /etc/caddy 0755 caddy users"
    "f /etc/caddy/caddy.env 0664 caddy users"
    "d /var/lib/caddy/ssl 0755 caddy caddy"
    "f /var/lib/caddy/ssl/key.pem 0664 caddy caddy"
    "f /var/lib/caddy/ssl/cert.pem 0664 caddy caddy"
  ];

  security.acme.certs."lldap.ggvv.org" = {
    dnsProvider = "porkbun";
    environmentFile = "/var/caddy/caddy.env";
    group = "services";
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/greenpau/caddy-security@v1.1.31"];
      hash = "sha256-aM5UdzmqOwGcdQUzDAEEP30CC1W2UPD10QhF0i7GwQE=";
    };

    environmentFile = "/etc/caddy/caddy.env";
    email = "hostmaster@lesgrandsvoisins.com";

    globalConfig = ''
      order authenticate before respond
      order authorize before basicauth

      security {
        oauth identity provider keycloak {
          driver generic
          realm keycloak
          client_id {env.KEYCLOAK_CLIENT_ID}
          client_secret {env.KEYCLOAK_CLIENT_SECRET}
          scopes profile openid email
          extract all from userinfo
          metadata_url https://keycloak.gdvoisins.com/realms/master/.well-known/openid-configuration
        }

        authentication portal keygdvoisinscom {
          crypto default token lifetime 3600
          crypto key sign-verify {env.JWT_SHARED_KEY}
          enable identity provider keycloak
          cookie domain ggvv.org
          ui {
            links {
              "Dashy" https://ggvv.org:443/ icon "las la-star"
              "Moi" "/whoami" icon "las la-user"
            }
          }

          transform user {
            match origin keycloak
            action add role authp/user
          }
        }

        authorization policy identifiedpolicy {
          set auth url https://auth.ggvv.org
          allow roles guest authp/admin authp/user
          crypto key verify {env.JWT_SHARED_KEY}
          set user identity subject
          inject headers with claims
          inject header "X-Useremail" from "email"
          inject header "X-Username" from "userinfo|preferred_username"
        }

        authorization policy userpolicy {
          set auth url https://auth.ggvv.org
          allow roles authp/admin authp/user
          crypto key verify {env.JWT_SHARED_KEY}
          inject headers with claims
        }

      }
    '';

    virtualHosts = {
      "wiki.whowhatetc.com" = {
        extraConfig = ''
          redir https://wiki.ggvv.org
        '';
      };
      "www.whowhatetc.com" = {
        extraConfig = ''
          redir https://www.ggvv.org
        '';
      };
      "whowhatetc.com" = {
        extraConfig = ''
          redir https://ggvv.org{uri}
        '';
      };
      "auth.whowhatetc.com" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "test.whowhatetc.com" = {
        extraConfig = ''
          redir https://test.ggvv.org{uri}
        '';
      };
      "maelanc.whowhatetc.com" = {
        extraConfig = ''
          redir https://maelanc.ggvv.org{uri}
        '';
      };
      "homarr.whowhatetc.com" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "homarr.ggvv.org" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "www.gvois.com" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "gvois.com" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "gvois.org" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "www.gvois.org" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "gvois.grandsvoisins.com" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org{uri} 301
        '';
      };
      "lldap.whowhatetc.com" = {
        extraConfig = ''
          redir https://lldap.ggvv.org{uri}
        '';
      };
      "forgejo.whowhatetc.com" = {
        extraConfig = ''
          redir https://forgejo.ggvv.org{uri}
        '';
      };
      "dashy.whowhatetc.com" = {
        extraConfig = ''
          redir https://dashy.ggvv.org{uri}
        '';
      };

      ############################

      "keycloak.grandsvoisins.org" = {
        extraConfig = ''
          # caddy trust /etc/keycloak/certs/keycloak.pem
          reverse_proxy https://[2a01:4f8:241:4faa::11] 
        '';
      };
      "wiki.ggvv.org" = {
        extraConfig = ''
          reverse_proxy http://[::1]:3480
        '';
      };
      "wiki.grandsvoisins.org" = {
        extraConfig = ''
          reverse_proxy http://[::1]:3480
        '';
      };
      "www.ggvv.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "a11yproject.lgv.info" = {
        extraConfig = ''
          root * /var/www/a11yproject.lgv.info/dist
          file_server
        '';
      };
      "ggvv.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "www.quiquoietc.com" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org
        '';
      };
      "quiquoietc.com" = {
        extraConfig = ''
          redir https://gvois.grandsvoisins.org
        '';
      };
      "auth.ggvv.org" = {
        extraConfig = ''
          authenticate with keygdvoisinscom
          respond "auth.ggvv.org is running"
        '';
      };
      "test.ggvv.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "maelanc.ggvv.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:8090
        '';
      };
      "maelanc.quiquoietc.com" = {
        extraConfig = ''
          reverse_proxy http://localhost:8090
        '';
      };
      "gvois.grandsvoisins.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "lldap.ggvv.org" = {
        extraConfig = ''
          reverse_proxy http://0.0.0.0:17170
        '';
      };
      "forgejo.ggvv.org" = {
        extraConfig = ''
          reverse_proxy http://0.0.0.0:3003
        '';
      };
      "dashy.ggvv.org" = {
        extraConfig = ''
          authorize with identifiedpolicy
          reverse_proxy https://max.local:8443 {
            transport http {
              tls_server_name max.local
              tls_insecure_skip_verify
              tls_client_auth /var/lib/caddy/ssl/cert.pem /var/lib/caddy/ssl/key.pem
            }
          }
        '';
      };
    };
  };
}
