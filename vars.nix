{
  gid.caddy = 239;
  gid.users = 100;
  gid.services = 500;
  uid.caddy = 239;
  uid.homarr = 1002; # Ce n'est plus utilisé
  uid.mael = 1003;
  uid.mannchri = 1000;
  uid.lldap = 501;
  uid.wiki-js = 502;
  uid.keycloak = 503;
  ports.postgresql = 5434;
  ports.wiki-js-www-https = 3443;
  ports.wiki-js-www-http = 3480;
  ports.wiki-js-doc-https = 3444;
  ports.redis-services-homarr = 6379;
  ports.lldap-ldaps = 3636;
  ports.lldap-http = 17170;
  ports.lldap-ldap = 3890;
  ips.wiki-js = "::1";
  domains.wiki-js = "wiki.ggvv.org";
  hetzner.interfaces = [
    {
      mac = "90:1b:0e:9e:ec:37";
    }
  ];
  hetzner.ipv4 = [
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
  hetzner.ipv6 = [
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
  hetzner.interface = "eth0";
}
