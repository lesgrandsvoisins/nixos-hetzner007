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
    # group = "services";
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

        authorization policy httpxpolicy {
          set auth url https://auth.ggvv.org
          crypto key verify {env.JWT_SHARED_KEY}
          allow roles guest authp/admin authp/user
          # acl default allow
          # acl default allow
          # allow any
          # allow roles anonymous guest
          # default allow
          inject headers with claims
          inject header "HTTP_X_REMOTE_USER" from "userinfo|preferred_username"
          inject header "X_REMOTE_USER" from "userinfo|preferred_username"
          inject header "REMOTE_USER" from "userinfo|preferred_username"
          inject header "HTTP_REMOTE_USER" from "userinfo|preferred_username"
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
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "keepass.gv.je" = {
        extraConfig = ''
          file_server /var/www/keeweb/
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
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "homarr.ggvv.org" = {
        extraConfig = ''
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "www.gvois.com" = {
        extraConfig = ''
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "gvois.com" = {
        extraConfig = ''
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "gvois.org" = {
        extraConfig = ''
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "gv.je" = {
        extraConfig = ''
          redir https://www.gv.je{uri} 301
        '';
      };
      "www.gv.je" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "gvplace.com" = {
        serverAliases = ["www.gvplace.com"];
        extraConfig = ''
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "libregood.com" = {
        extraConfig = ''
          redir https://www.libregood.com{uri} 301
        '';
      };
      "hopgv.com" = {
        serverAliases = [
          "www.hopgv.com"
          "hopgv.org"
          "www.hopgv.org"
          "gafam.us"
          "www.gafam.us"
          "gdvoisins.org"
        ];
        extraConfig = "redir https://www.gdvoisins.org{uri} 301";
      };
      # "lesgv.com" = {
      #   extraConfig = ''
      #     redir https://www.gdvoisins.org{uri} 301
      #   '';
      # };
      # "www.lesgv.com" = {
      #   extraConfig = ''
      #     redir https://www.gdvoisins.org{uri} 301
      #   '';
      # };
      # "lesgv.org" = {
      #   extraConfig = ''
      #     redir https://www.gdvoisins.org{uri} 301
      #   '';
      # };
      # "www.lesgv.org" = {
      #   extraConfig = ''
      #     redir https://www.gdvoisins.org{uri} 301
      #   '';
      # };
      "www.gvois.org" = {
        extraConfig = ''
          redir https://www.gdvoisins.org{uri} 301
        '';
      };
      "gvois.grandsvoisins.com" = {
        extraConfig = ''
          redir https://www.gdvoisins.org{uri} 301
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

      "key.gv.je" = {
        extraConfig = ''
          #  caddy trust /etc/keycloak/certs/keycloak.local.pem
          # caddy trust /var/lib/acme/key.gv.je/fullchain.pem;
          reverse_proxy https://[::]:14446 {
            transport http {
                tls
                tls_server_name key.gv.je
                # tls_insecure_skip_verify # Change this
                tls_trust_pool file {
                  pem_file /var/lib/acme/key.gv.je/fullchain.pem
                }
                # header_up Host {upstream_hostport}
                # header_up X-Real-IP {remote}
                # header_up X-Forwarded-For {remote}
                # header_up X-Forwarded-Port {server_port}
                # header_up X-Forwarded-Proto {scheme}
            }
          }
        '';
      };

      "admin.key.gv.je" = {
        extraConfig = ''
          #  caddy trust /etc/keycloak/certs/keycloak.local.pem
          reverse_proxy https://[::]:14446 {
            transport http {
                tls
                tls_server_name admin.key.gv.je
                # tls_insecure_skip_verify # Change this
                tls_trust_pool file {
                  pem_file /var/lib/acme/key.gv.je/fullchain.pem
                }
                # header_up Host {upstream_hostport}
                # header_up X-Real-IP {remote}
                # header_up X-Forwarded-For {remote}
                # header_up X-Forwarded-Port {server_port}
                # header_up X-Forwarded-Proto {scheme}
            }
          }
        '';
      };
      "keycloak.grandsvoisins.org" = {
        extraConfig = ''
          #  caddy trust /etc/keycloak/certs/keycloak.local.pem
          reverse_proxy https://keycloak.local {
            transport http {
                tls
                tls_server_name keycloak.local
                # tls_insecure_skip_verify # Change this
                tls_trust_pool file {
                  pem_file /etc/keycloak/certs/keycloak.local.pem
                }
                # header_up Host {upstream_hostport}
                # header_up X-Real-IP {remote}
                # header_up X-Forwarded-For {remote}
                # header_up X-Forwarded-Port {server_port}
                # header_up X-Forwarded-Proto {scheme}
            }
          }
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
      "vw.gv.je" = {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy https://vaultwarden.local:${toString config.services.vaultwarden.config.ROCKET_PORT} {
           header_up X-Real-IP {remote_host}
           transport http {
                tls
                tls_server_name vaultwarden.local
                tls_trust_pool file {
                  pem_file /etc/vaultwarden/.tls/vaultwarden.local.pem
                }
            }

          }
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
      "je.0.grandsvoisins.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "pcal.gv.je" = {
        # "pcal.grandsvoisins.org" = {
        extraConfig = ''
          # @not_get {
          #   not method GET
          # }
          # respond @not_get "Method Not Allowed" 405
          reverse_proxy http://localhost:${builtins.toString vars.ports.radicale-public}
        '';
      };
      "je.1.grandsvoisins.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "info.grandsvoisins.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "je.grandsvoisins.org" = {
        extraConfig = ''
          # reverse_proxy http://localhost:3000
          redir https://www.gv.je{uri} 301
        '';
      };
      "www.quiquoietc.com" = {
        extraConfig = ''
          redir https://www.gdvoisins.org
        '';
      };
      "quiquoietc.com" = {
        extraConfig = ''
          redir https://www.gdvoisins.org
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
      "www.gdvoisins.org" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
        '';
      };
      "1.gv.je" = {
        extraConfig = ''
          respond "Hello [2a01:4f8:a0:73ba::1]"
        '';
      };
      "0.gv.je" = {
        extraConfig = ''
          respond "Hello [2a01:4f8:a0:73ba::]"
        '';
      };
      "www.libregood.com" = {
        extraConfig = ''
          reverse_proxy https://wiki-js-libregood.local:${builtins.toString vars.ports.wiki-js-libregood-https} {
          # reverse_proxy http://wiki-js-libregood.local:${builtins.toString vars.ports.wiki-js-libregood-http} {

           transport http {
                tls
                tls_server_name wiki-js-libregood.local
                tls_trust_pool file {
                  pem_file /etc/wiki-js-libregood/certs/wiki-js-libregood.local.pem
                }
            }
          }
        '';
      };
      # "www.gv.je" = {
      #   extraConfig = ''
      #     reverse_proxy http://localhost:3000
      #   '';
      # };
      "lesgv.grandsvoisins.org" = {
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

      "xcal.gv.je" = {
        # "xcal.grandsvoisins.org" = {
        extraConfig = ''
          authorize with identifiedpolicy
          reverse_proxy http://localhost:${builtins.toString vars.ports.xandikos}
        '';
      };
      "rcal.gv.je" = {
        # "rcal.grandsvoisins.org" = {
        extraConfig = ''
          reverse_proxy https://radicale.local:${builtins.toString vars.ports.radicale} {
           transport http {
                tls
                tls_server_name radicale.local
                tls_trust_pool file {
                  pem_file /etc/radicale/certs/radicale.local.pem
                }
            }
          }
        '';
      };
      # "cal.gdvoisins.com" = {
      #   extraConfig = ''
      #     reverse_proxy https://radicale.local:${builtins.toString vars.ports.radicale} {
      #       header_up HTTP_X_REMOTE_USER "public"
      #       header_up X_REMOTE_USER "public"
      #       header_up REMOTE_USER "public"
      #       header_up HTTP_REMOTE_USER "public"
      #       header_down HTTP_X_REMOTE_USER "public"
      #       header_down X_REMOTE_USER "public"
      #       header_down REMOTE_USER "public"
      #       header_down HTTP_REMOTE_USER "public"
      #       transport http {
      #         tls
      #         tls_server_name radicale.local
      #         tls_trust_pool file {
      #           pem_file /etc/radicale/certs/radicale.local.pem
      #         }
      #       }
      #     }
      #   '';
      # };
    };
  };
}
