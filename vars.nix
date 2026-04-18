{
  gid = {
    caddy = 239;
    users = 100;
    services = 500;
    radicale = 504;
    named = 989;
    sftpgo = 1506;
    node-red = 1507;
  };
  uid = {
    caddy = 239;
    homarr = 1002; # Ce n'est plus utilisé
    mael = 1003;
    mannchri = 1000;
    lldap = 501;
    wiki-js = 502;
    keycloak = 503;
    radicale = 504;
    services = 500;
    syncin = 1505;
    sftpgo = 1506;
    node-red = 1507;
    vikunja = 1508;
    gitea = 1509;
    openldap = 1510;
    memos = 1511;
    named = 991;
    lemmy = 1512;
    freshrss = 1513;
    miniflux = 1514;
    immich = 1514;
    oxicloud = 1515;
    cherryldap = 11111;
  };
  ports = {
    postgresql = 5432;
    wiki-js-www-https = 3443;
    wiki-js-www-http = 3480;
    wiki-js-libregood-https = 3445;
    wiki-js-libregood-http = 3482;
    wiki-js-doc-https = 3444;
    wiki-js-doc-http = 3481;
    redis-services-homarr = 6379;
    lldap-ldaps = 3636;
    lldap-http = 17170;
    lldap-ldap = 3890;
    radicale = 5232;
    radicale-public = 5252;
    xandikos = 10888;
    sfptgo-httpd = 1280;
    sfptgo-sftp = 1282;
    sfptgo-webdav = 1281;
    node-red = 1507;
    gitea-https = 3446;
    gitea-ssh = 3022;
    ldap = 389;
    ldaps = 636;
    memos = 5230;
    homarr = 3000;
    lemmy-ui = 1234;
    lemmy-server = 8536;
    miniflux = 8088;
    immich = 2283;
    oxicloud = 8085;
  };
  hosts = {
    node-red = {
      ipv4 = "10.0.13.101";
      ipv6 = "fa13::101";
    };
    memos = {
      addr = "127.0.0.1";
    };
  };
  postgresql = {
    memos = {
      database = "memos";
      user = "memos";
      envFile = "/etc/memos/memos.env";
    };
    homarr = {
      database = "homarr";
      user = "homarr";
      envFile = "/etc/homarr/homarr.env";
    };
  };
  containers = {
    homarr2 = {
      network = {
        ipv4 = {
          host = "10.0.14.100";
          local = "10.0.14.101";
        };
        ipv6 = {
          host = "fa14::100";
          local = "fa14::101";
        };
        hostName = "homarr2";
        domain = "homarr2.lan";
      };
    };
    homarr = {
      network = {
        ipv4 = {
          host = "10.0.15.100";
          local = "10.0.15.101";
        };
        ipv6 = {
          host = "fa15::100";
          local = "fa15::101";
        };
        hostName = "homarr";
        lanName = "homarr.lan";
        wanName = "www.gv.je";
      };
    };
    cherryldap = {
      hostAddress = "192.168.106.1";
      localAddress = "192.168.106.2";
      hostAddress6 = "fc00::6:1";
      localAddress6 = "fc00::6:2";
      bindMounts = {
        "/var/local/cherryldap" = {
          hostPath = "/var/local/cherryldap";
          isReadOnly = false;
        };
      };
    };
    discourse = {};
    discourseparis14cc = {};
    haproxy = {};
    keycloakkeycloakgdvox = {};
    keycloakgvoiscom = {};
    keycloaklesgv = {};
    kecloakparis14cc = {};
    keycloakparisgv = {};
    keyresdigita = {};
    lgvldap = {};
    mm = {};
    openldap = {};
    silverbullet = {};
    triliumnext = {};
    vikunjaresdigita = {};
    wagtail = {};
    wiki-js = {};
    wordpress = {};
  };
  dirs = {
    sftpgo-users = "/srv/sftpgo/users";
  };
  ips.wiki-js = "::1";
  hetzner = {
    interfaces = [
      {
        mac = "90:1b:0e:9e:ec:37";
      }
    ];
    ipv4 = [
      {
        interface = "enx901b0e9eec37";
        addr = "213.239.216.138";
        gw = "213.239.216.159";
        netmask = "27";
      }
      {
        addr = "213.239.217.187";
        gw = "213.239.217.161";
        netmask = "27";
      }
    ];
    ipv6 = [
      {
        addr = "2a01:4f8:a0:73ba::";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::1";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::2";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::3";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::4";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::5";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::6";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::7";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::8";
        gw = "fe80::1";
        netmask = 64;
      }
      {
        addr = "2a01:4f8:a0:73ba::9";
        gw = "fe80::1";
        netmask = 64;
      }
    ];
    interface = "enp0s31f6";
  };
  domains = {
    ldap = "ldap.gv.je";
    memos = "memos.gv.je";
    wiki-js = "wiki.ggvv.org";
    lemmy = "lemmy.gv.je";
  };
  ldap = {
    baseDN = "dc=lesgrandsvoisins,dc=com";
  };
}
