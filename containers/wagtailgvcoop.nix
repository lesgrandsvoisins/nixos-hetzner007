{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  nginxLocationWagtailExtraConfig = ''
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-Proto $scheme;
    # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    # proxy_set_header Host $host;
    # proxy_set_header Upgrade $http_upgrade;
    # proxy_set_header Connection $connection_upgrade_keepalive;
  '';
  nginxLesGrandsVoisinsExtraConfig = ''
    # proxy_protocol off;
    if ($host = 'meet.resdigita.com') {
      return 302 https://jitsi.grandzine.org/resdigita;
    }
    if ($host = 'www.gdvoisins.org') {
      return 302 https://www.gdvoisins.com$request_uri;
    }
    if ($host = 'www.lesgrandsvoisins.fr') {
      return 302 https://www.lesgrandsvoisins.com$request_uri;
    }
    # Static assets: cache for a year (with versioned filenames)
    location ~* \.(?:css|js|woff2?|ttf|eot|ico|gif|jpg|jpeg|png|webp|svg)$ {
        expires 1w;
        add_header Cache-Control "public, max-age=31536000, immutable";
    }

    # HTML: cache very briefly (optional)
    location ~* \.(?:html)$ {
        expires 5m;
        add_header Cache-Control "public, max-age=300, must-revalidate";
    }

    # # API responses: no caching
    # location /api/ {
    #     add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";
    #     proxy_pass http://localhost:8080;
    # }

    # Optionally disable ETag if you rely on versioned files
    etag off;
  '';
  nginxLesGrandsVoisinsLocations = {
    "/" = {
      proxyPass = "http://localhost:${vars.ports.wagtailgvcoop}/";
      extraConfig = ''
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-Proto $scheme;

        # add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0";

        expires 5m;
        add_header Cache-Control "public, max-age=300, must-revalidate";

        # proxy_set_header Host $host;
        # proxy_set_header Upgrade $http_upgrade;
        # proxy_set_header Connection $connection_upgrade_keepalive;
        # return 302 $scheme://www.grandsvoisins.com$request_uri;

        rewrite ^/cms-admin/login/?$ /accounts/oidc/key-gv-je/login/?process=cms-admin/login/ redirect;
      '';
    };
    "/fr/accounts/profile/".extraConfig = ''
      return 302 /;
    '';
    "/en/accounts/profile/".extraConfig = ''
      return 302 /;
    '';
    "/favicon.ico" = {proxyPass = null;};
    "/static" = {proxyPass = null;};
    "/media" = {proxyPass = null;};
    "/medias" = {proxyPass = null;};
    "/.well-known" = {proxyPass = null;};
    "/index.php" = {
      extraConfig = ''
        return 404;
      '';
    };
  };
in {
  services.nginx.virtualHosts = {
    "www.gvcoop.org" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/wagtailgvcoop";
      locations."/" = {
        extraConfig = nginxLocationWagtailExtraConfig;
        proxyPass = "http://wagtailgvcoop.containers:${builtins.toString vars.ports.wagtailgvcoop}/";
      };
      locations."/favicon.ico" = {proxyPass = null;};
      locations."/static" = {proxyPass = null;};
      locations."/medias" = {proxyPass = null;};
      locations."/.well-known" = {proxyPass = null;};
      locations."/fr/accounts/profile/".extraConfig = ''
        return 302 /;
      '';
      locations."/en/accounts/profile/".extraConfig = ''
        return 302 /;
      '';
    };
  };
  users = {
    users.wagtailgvcoop = {
      group = "services";
      uid = vars.uid.wagtailgvcoop;
      isSystemUser = true;
    };
  };
  networking.hosts = {
    "${vars.containers.wagtailgvcoop.hostAddress}" = ["wagtailgvcoop.containers"];
  };
  systemd.tmpfiles.rules = [
    "d /etc/wagtailgvcoop 0775 wagtailgvcoop services"
    "d /var/www/wagtailgvcoop 0775 wagtailgvcoop services"
  ];
  containers.wagtailgvcoop = {
    hostAddress = vars.containers.wagtailgvcoop.hostAddress;
    localAddress = vars.containers.wagtailgvcoop.localAddress;
    hostAddress6 = vars.containers.wagtailgvcoop.hostAddress6;
    localAddress6 = vars.containers.wagtailgvcoop.localAddress6;
    bindMounts = vars.containers.wagtailgvcoop.bindMounts;
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
        users.wagtailgvcoop = {
          group = "services";
          uid = vars.uid.wagtailgvcoop;
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
        "d /etc/wagtailgvcoop 0775 wagtailgvcoop services"
        "d /var/www/wagtailgvcoop 0775 wagtailgvcoop services"
      ];

      systemd.services.wagtail-coopgv = {
        description = "www.gvcoop'org on ";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          WorkingDirectory = "/home/wagtail/coopgv/";
          ExecStart = ''/home/wagtailgvcoop/gvcooporg/www --env WAGTAIL_ENV='production' --access-logfile /var/log/wagtailgvcoop-access.log --error-logfile /var/log/wagtailgvcoop-error.log --chdir /home/wagtailgvcoop/gvcooporg/www --workers 12 --bind 0.0.0.0:${vars.ports.wagtailgvcoop} mysite.wsgi:application'';
          Restart = "always";
          RestartSec = "10s";
          User = "wagtail";
          Group = "users";
        };
        unitConfig = {
          StartLimitInterval = "1min";
        };
      };
    };
  };
}
