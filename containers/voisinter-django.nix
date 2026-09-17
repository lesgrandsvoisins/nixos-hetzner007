{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.postgresql = {
    ensureUsers = [
      {
        name = "voisinter-django";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = ["voisinter-django"];
    authentication = lib.mkAfter ''
      hostssl voisinter-django voisinter-django ${vars.containers.voisinter-django.localAddress}/32 scram-sha-256
    '';
  };
  services.caddy.virtualHosts."${vars.domains.voisinter-dev}" = {
    extraConfig = ''
      handle /static/* {
          root * /var/www/voisinter-dev
          file_server
      }
      handle /media/* {
          root * /var/www/voisinter-dev
          file_server
      }

      handle {
          reverse_proxy http://${vars.containers.voisinter-django.localAddress}:${builtins.toString vars.ports.voisinter-dev}
      }
    '';
  };
  services.caddy.virtualHosts."${vars.domains.lesgrandsvoisinsfr}" = {
    extraConfig = ''
      redir https://${vars.domains.newlesgrandsvoisinsfr}{uri}
    '';
  };
  services.caddy.virtualHosts."${vars.domains.voisinter}" = {
    extraConfig = ''
      redir https://${vars.domains.newlesgrandsvoisinsfr}{uri}
    '';
    # extraConfig = ''
    #   handle /static/* {
    #       root * /var/www/voisinter-django
    #       file_server
    #   }
    #   handle /media/* {
    #       root * /var/www/voisinter-django
    #       file_server
    #   }

    #   handle {
    #       reverse_proxy http://${vars.containers.voisinter-django.localAddress}:${builtins.toString vars.ports.voisinter-django}
    #   }
    # '';
  };

  services.caddy.virtualHosts."lesgrandsvoisins.fr" = {
    extraConfig = ''
      redir https://${vars.domains.lesgrandsvoisinsfr}{uri}
    '';
  };
  services.caddy.virtualHosts."gdvoisins.com" = {
    extraConfig = ''
      redir https://${vars.domains.gdvoisinscom}{uri}
    '';
  };
  services.caddy.virtualHosts."${vars.domains.gdvoisinscom}" = {
    extraConfig = ''
      redir https://${vars.domains.newlesgrandsvoisinsfr}{uri}
    '';
  };
  services.caddy.virtualHosts."${vars.domains.newlesgrandsvoisinsfr}" = {
    extraConfig = ''
      handle /static/* {
          root * /var/www/voisinter-django
          file_server
      }
      handle /media/* {
          root * /var/www/voisinter-django
          file_server
      }

      handle {
          reverse_proxy http://${vars.containers.voisinter-django.localAddress}:${builtins.toString vars.ports.voisinter-django}
      }
    '';
  };
  users = {
    users.voisinter-django = {
      group = "services";
      uid = vars.uid.voisinter-django;
      isSystemUser = true;
    };
  };
  networking.hosts = {
    "${vars.containers.voisinter-django.hostAddress}" = ["voisinter-django.containers"];
  };
  systemd.tmpfiles.rules = [
    "d /etc/voisinter-django 0775 voisinter-django services"
    "d /var/www/voisinter-django 0775 voisinter-django services"
    "d /var/www/voisinter-dev 0775 voisinter-django services"
    "d /var/www/voisinter-dev/media 0775 voisinter-django services"
    "d /var/www/voisinter-dev/static 0775 voisinter-django services"
  ];
  containers."voisinter-django" = {
    hostAddress = vars.containers.voisinter-django.hostAddress;
    localAddress = vars.containers.voisinter-django.localAddress;
    hostAddress6 = vars.containers.voisinter-django.hostAddress6;
    localAddress6 = vars.containers.voisinter-django.localAddress6;
    bindMounts = vars.containers.voisinter-django.bindMounts;
    privateNetwork = true;
    autoStart = true;

    config = {
      config,
      pkgs,
      lib,
      vars,
      ...
    }: let
      vars = import ../vars.nix;
    in {
      system.stateVersion = "26.05";
      nix.settings.experimental-features = "nix-command flakes";
      networking.useHostResolvConf = lib.mkForce false;
      services.resolved.enable = true;

      users = {
        users.voisinter-django = {
          group = "services";
          uid = vars.uid.voisinter-django;
          isNormalUser = true;
        };
      };

      users.groups.services = {
        gid = vars.gid.services;
      };

      imports = [
        ../modules/packages/common.nix
        ../modules/packages/vim.nix
      ];

      systemd.tmpfiles.rules = [
        "d /var/voisinter/voisinter/media 0775 voisinter-django services"
        "d /etc/voisinter-django 0775 voisinter-django services"
        "d /var/www/voisinter-django 0775 voisinter-django services"
        "d /var/www/voisinter-django/static 0775 voisinter-django services"
        "d /var/www/voisinter-django/media 0775 voisinter-django services"
        "d /var/cache/voisinter-django 0750 voisinter-django services"
        "d /home/voisinter-django/voisinter-dev 0755 voisinter-django services"
      ];

      environment.systemPackages = with pkgs; [
        sqlite
      ];

      systemd.services.voisinter-django = let
        # voisinternet = pkgs.callPackage ../derivations/voisinternet/package.nix {};
      in {
        description = "${vars.domains.voisinter} on voisinter-django";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        environment = {
          # BASE_DIR (the Nix store path) is read-only, so every writable
          # path Django would otherwise derive from it must be pointed at a
          # bind-mounted or tmpfiles-managed directory instead.
          DJANGO_STATIC_ROOT = "/var/voisinter/voisinter/staticfiles";
          DJANGO_MEDIA_ROOT = "/var/voisinter/voisinter/var/media";
          DJANGO_CACHE_DIR = "/var/cache/voisinter-django";
        };
        serviceConfig = {
          EnvironmentFile = "-/etc/voisinter-django/voisinter-django.env";
          # WorkingDirectory = "${voisinternet}/share/voisinternet";
          WorkingDirectory = "/var/voisinter/voisinter";
          ExecStartPre = [
            "/var/voisinter/voisinter/.venv/bin/python manage.py migrate --noinput"
            "/var/voisinter/voisinter/.venv/bin/python manage.py collectstatic --noinput"
          ];
          ExecStart = ''/var/voisinter/voisinter/.venv/bin/gunicorn --access-logfile /var/voisinter/voisinter-django-access.log --error-logfile /var/voisinter/voisinter-django-error.log --workers 4 --bind 0.0.0.0:${builtins.toString vars.ports.voisinter-django} voisinternet.wsgi:application'';
          # ExecStartPre = [
          #   "${voisinternet}/bin/voisinternet-manage migrate --noinput"
          #   "${voisinternet}/bin/voisinternet-manage collectstatic --noinput"
          # ];
          # ExecStart = ''${voisinternet}/bin/voisinternet-gunicorn --access-logfile /var/voisinter/voisinter-django-access.log --error-logfile /var/voisinter/voisinter-django-error.log --workers 4 --bind 0.0.0.0:${builtins.toString vars.ports.voisinter-django} voisinternet.wsgi:application'';
          Restart = "always";
          RestartSec = "10s";
          User = "voisinter-django";
          Group = "services";
        };
        unitConfig = {
          StartLimitInterval = "1min";
        };
      };
      networking.firewall.enable = false;
    };
  };
}
