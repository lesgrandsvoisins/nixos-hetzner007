{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.caddy.virtualHosts."${vars.domains.voisinter}" = {
    extraConfig = ''
      handle /static/* {
          root * /var/www/voisinter-django
          file_server
      }
      handle /media/* {
          root * /var/voisinter/voisinter/var/
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
        "d /etc/voisinter-django 0775 voisinter-django services"
        "d /var/www/voisinter-django 0775 voisinter-django services"
      ];

      systemd.services.voisinter-django = {
        description = "${vars.domains.voisinter} on voisinter-django";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          WorkingDirectory = "/home/voisinter-django/voisinter/www";
          ExecStart = ''/home/voisinter-django/voisinter/.venv/bin/gunicorn --access-logfile /home/voisinter-django/voisinter-django-access.log --error-logfile /home/voisinter-django/voisinter-django-error.log --chdir /home/voisinter-django/voisinter/www --workers 4 --bind 0.0.0.0:${builtins.toString vars.ports.voisinter-django} voisinter.wsgi:application'';
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
