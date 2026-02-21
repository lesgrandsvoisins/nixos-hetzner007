{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  users.users.named.uid = vars.uid.named;
  users.users.named.group = "named";
  users.groups.named.gid = vars.gid.named;
  systemd.tmpfiles.rules = [
    "d /var/lib/bind/zones 0775 named named"
  ];
  services.bind = {
    enable = true;
    zones = {
      "configmagic.com" = {
        file = "/var/lib/bind/zones/configmagic.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "configmagic.com";
      };
      "coolgv.com" = {
        file = "/var/lib/bind/zones/coolgv.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "coolgv.com";
      };
      "coolgv.org" = {
        file = "/var/lib/bind/zones/coolgv.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "coolgv.org";
      };
      "coopgv.com" = {
        file = "/var/lib/bind/zones/coopgv.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "coopgv.com";
      };
      "franc.paris" = {
        file = "/var/lib/bind/zones/franc.paris.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "franc.paris";
      };
      "gafam.us" = {
        file = "/var/lib/bind/zones/gafam.us.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gafam.us";
      };
      "gdv1.com" = {
        file = "/var/lib/bind/zones/gdv1.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gdv1.com";
      };
      "gdv1.org" = {
        file = "/var/lib/bind/zones/gdv1.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gdv1.org";
      };
      "gdvoisins.com" = {
        file = "/var/lib/bind/zones/gdvoisins.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gdvoisins.com";
      };
      "gdvoisins.org" = {
        file = "/var/lib/bind/zones/gdvoisins.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gdvoisins.org";
      };
      "gdvox.com" = {
        file = "/var/lib/bind/zones/gdvox.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gdvox.com";
      };
      "ggvv.org" = {
        file = "/var/lib/bind/zones/ggvv.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "ggvv.org";
      };
      "grandsvoisins.com" = {
        file = "/var/lib/bind/zones/grandsvoisins.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "grandsvoisins.com";
      };
      "grandsvoisins.fr" = {
        file = "/var/lib/bind/zones/grandsvoisins.fr.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "grandsvoisins.fr";
      };
      "grandsvoisins.org" = {
        file = "/var/lib/bind/zones/grandsvoisins.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "grandsvoisins.org";
      };
      "grandv.org" = {
        file = "/var/lib/bind/zones/grandv.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "grandv.org";
      };
      "grandzine.com" = {
        file = "/var/lib/bind/zones/grandzine.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "grandzine.com";
      };
      "grandzine.org" = {
        file = "/var/lib/bind/zones/grandzine.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "grandzine.org";
      };
      "gvcoop.org" = {
        file = "/var/lib/bind/zones/gvcoop.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gvcoop.org";
      };
      "gv.coop" = {
        file = "/var/lib/bind/zones/gv.coop.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gv.coop";
      };
      "gv.je" = {
        file = "/var/lib/bind/zones/gv.je.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gv.je";
      };
      "gvois.com" = {
        file = "/var/lib/bind/zones/gvois.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gvois.com";
      };
      "gvois.org" = {
        file = "/var/lib/bind/zones/gvois.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gvois.org";
      };
      "gvplace.com" = {
        file = "/var/lib/bind/zones/gvplace.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gvplace.com";
      };
      "gvstyle.com" = {
        file = "/var/lib/bind/zones/gvstyle.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gvstyle.com";
      };
      "gv.style" = {
        file = "/var/lib/bind/zones/gv.style.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "gv.style";
      };
      "hopgv.org" = {
        file = "/var/lib/bind/zones/hopgv.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "hopgv.org";
      };
      "l14s.com" = {
        file = "/var/lib/bind/zones/l14s.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "l14s.com";
      };
      "lesgrandsvoisins.com" = {
        file = "/var/lib/bind/zones/lesgrandsvoisins.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "lesgrandsvoisins.com";
      };
      "lesgv.com" = {
        file = "/var/lib/bind/zones/lesgv.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "lesgv.com";
      };
      "lesgv.org" = {
        file = "/var/lib/bind/zones/lesgv.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "lesgv.org";
      };
      "lesgvs.com" = {
        file = "/var/lib/bind/zones/lesgvs.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "lesgvs.com";
      };
      "lgv1.com" = {
        file = "/var/lib/bind/zones/lgv1.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "lgv1.com";
      };
      "lgv.info" = {
        file = "/var/lib/bind/zones/lgv.info.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "lgv.info";
      };
      "libregood.com" = {
        file = "/var/lib/bind/zones/libregood.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "libregood.com";
      };
      "maelanc.com" = {
        file = "/var/lib/bind/zones/maelanc.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "maelanc.com";
      };
      "pargv.com" = {
        file = "/var/lib/bind/zones/pargv.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "pargv.com";
      };
      "paris14.cc" = {
        file = "/var/lib/bind/zones/paris14.cc.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "paris14.cc";
      };
      "parisgv.com" = {
        file = "/var/lib/bind/zones/parisgv.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "parisgv.com";
      };
      "parisgv.org" = {
        file = "/var/lib/bind/zones/parisgv.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "parisgv.org";
      };
      "parisle.com" = {
        file = "/var/lib/bind/zones/parisle.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "parisle.com";
      };
      "parislenuage.com" = {
        file = "/var/lib/bind/zones/parislenuage.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "parislenuage.com";
      };
      "parisle.org" = {
        file = "/var/lib/bind/zones/parisle.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "parisle.org";
      };
      "quiquequoi.com" = {
        file = "/var/lib/bind/zones/quiquequoi.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "quiquequoi.com";
      };
      "quiquoietc.com" = {
        file = "/var/lib/bind/zones/quiquoietc.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "quiquoietc.com";
      };
      "resdigita.com" = {
        file = "/var/lib/bind/zones/resdigita.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "resdigita.com";
      };
      "whowhatetc.com" = {
        file = "/var/lib/bind/zones/whowhatetc.com.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "whowhatetc.com";
      };
      "yanlomsprod.org" = {
        file = "/var/lib/bind/zones/yanlomsprod.org.txt";
        master = true;
        slaves = ["116.202.236.241" "2a01:4f8:241:4faa::"];
        name = "yanlomsprod.org";
      };
    };
  };
}
