{
  config,
  pkgs,
  lib,
  ...
}: let
  # caddy-ui-lesgrandsvoisins = pkgs.callPackage ./derivations/caddy-ui-lesgrandsvoisins.nix {};
  vars = ../../vars.nix;
in {
  systemd.tmpfiles.rules = [
    "d /etc/caddy 0755 caddy users"
    "f /etc/caddy/caddy.env 0664 caddy users"
    "d /var/lib/caddy/ssl 0755 caddy caddy"
    "f /var/lib/caddy/ssl/key.pem 0664 caddy caddy"
    "f /var/lib/caddy/ssl/cert.pem 0664 caddy caddy"
  ];

  security.acme.certs."lldap.whowhatetc.com" = {
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
          cookie domain whowhatetc.com
          ui {
            links {
              "Dashy" https://whowhatetc.com:443/ icon "las la-star"
              "Moi" "/whoami" icon "las la-user"
            }
          }

          transform user {
            match origin keycloak
            action add role authp/user
          }
        }

        authorization policy identifiedpolicy {
          set auth url https://auth.whowhatetc.com
          allow roles guest authp/admin authp/user
          crypto key verify {env.JWT_SHARED_KEY}
          set user identity subject
          inject headers with claims
          inject header "X-Useremail" from "email"
          inject header "X-Username" from "userinfo|preferred_username"
        }

        authorization policy userpolicy {
          set auth url https://auth.whowhatetc.com
          allow roles authp/admin authp/user
          crypto key verify {env.JWT_SHARED_KEY}
          inject headers with claims
        }

      }
    '';

    virtualHosts = {
      "${vars.domains.wiki-js}" = {
        extraConfig = ''
          reverse_proxy https://[::1]:3443
        '';
      };
      "www.whowhatetc.com" = {
        extraConfig = ''
          redir https://homarr.whowhatetc.com
        '';
      };
      "a11yproject.lgv.info" = {
        extraConfig = ''
          root * /var/www/a11yproject.lgv.info/dist
          file_server
        '';
      };
      "whowhatetc.com" = {
        extraConfig = ''
          redir https://homarr.whowhatetc.com
        '';
      };
      "www.quiquoietc.com" = {
        extraConfig = ''
          redir https://homarr.whowhatetc.com
        '';
      };
      "quiquoietc.com" = {
        extraConfig = ''
          redir https://homarr.whowhatetc.com
        '';
      };
      "auth.whowhatetc.com" = {
        extraConfig = ''
          authenticate with keygdvoisinscom
          respond "auth.whowhatetc.com is running"
        '';
      };
      "test.whowhatetc.com" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "maelanc.whowhatetc.com" = {
        extraConfig = ''
          reverse_proxy http://localhost:8090
        '';
      };
      "maelanc.quiquoietc.com" = {
        extraConfig = ''
          reverse_proxy http://localhost:8090
        '';
      };
      "homarr.whowhatetc.com" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "lldap.whowhatetc.com" = {
        extraConfig = ''
          reverse_proxy http://0.0.0.0:17170
        '';
      };
      "forgejo.whowhatetc.com" = {
        extraConfig = ''
          reverse_proxy http://0.0.0.0:3003
        '';
      };
      "dashy.whowhatetc.com" = {
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
