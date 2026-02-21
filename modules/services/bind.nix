{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.bind = {
    enable = true;
    zones = {
      "configmagic.com" = {
        file = "/etc/bind/zones/configmagic.com.txt";
        master = true;
        name = "configmagic.com";
      };
      "coolgv.com" = {
        file = "/etc/bind/zones/coolgv.com.txt";
        master = true;
        name = "coolgv.com";
      };
      "coolgv.org" = {
        file = "/etc/bind/zones/coolgv.org.txt";
        master = true;
        name = "coolgv.org";
      };
      "coopgv.com" = {
        file = "/etc/bind/zones/coopgv.com.txt";
        master = true;
        name = "coopgv.com";
      };
      "franc.paris" = {
        file = "/etc/bind/zones/franc.paris.txt";
        master = true;
        name = "franc.paris";
      };
      "gafam.us" = {
        file = "/etc/bind/zones/gafam.us.txt";
        master = true;
        name = "gafam.us";
      };
      "gdv1.com" = {
        file = "/etc/bind/zones/gdv1.com.txt";
        master = true;
        name = "gdv1.com";
      };
      "gdv1.org" = {
        file = "/etc/bind/zones/gdv1.org.txt";
        master = true;
        name = "gdv1.org";
      };
      "gdvoisins.com" = {
        file = "/etc/bind/zones/gdvoisins.com.txt";
        master = true;
        name = "gdvoisins.com";
      };
      "gdvoisins.org" = {
        file = "/etc/bind/zones/gdvoisins.org.txt";
        master = true;
        name = "gdvoisins.org";
      };
      "gdvox.com" = {
        file = "/etc/bind/zones/gdvox.com.txt";
        master = true;
        name = "gdvox.com";
      };
      "ggvv.org" = {
        file = "/etc/bind/zones/ggvv.org.txt";
        master = true;
        name = "ggvv.org";
      };
      "grandsvoisins.com" = {
        file = "/etc/bind/zones/grandsvoisins.com.txt";
        master = true;
        name = "grandsvoisins.com";
      };
      "grandsvoisins.fr" = {
        file = "/etc/bind/zones/grandsvoisins.fr.txt";
        master = true;
        name = "grandsvoisins.fr";
      };
      "grandsvoisins.org" = {
        file = "/etc/bind/zones/grandsvoisins.org.txt";
        master = true;
        name = "grandsvoisins.org";
      };
      "grandv.org" = {
        file = "/etc/bind/zones/grandv.org.txt";
        master = true;
        name = "grandv.org";
      };
      "grandzine.com" = {
        file = "/etc/bind/zones/grandzine.com.txt";
        master = true;
        name = "grandzine.com";
      };
      "grandzine.org" = {
        file = "/etc/bind/zones/grandzine.org.txt";
        master = true;
        name = "grandzine.org";
      };
      "gvcoop.org" = {
        file = "/etc/bind/zones/gvcoop.org.txt";
        master = true;
        name = "gvcoop.org";
      };
      "gv.coop" = {
        file = "/etc/bind/zones/gv.coop.txt";
        master = true;
        name = "gv.coop";
      };
      "gv.je" = {
        file = "/etc/bind/zones/gv.je.txt";
        master = true;
        name = "gv.je";
      };
      "gvois.com" = {
        file = "/etc/bind/zones/gvois.com.txt";
        master = true;
        name = "gvois.com";
      };
      "gvois.org" = {
        file = "/etc/bind/zones/gvois.org.txt";
        master = true;
        name = "gvois.org";
      };
      "gvplace.com" = {
        file = "/etc/bind/zones/gvplace.com.txt";
        master = true;
        name = "gvplace.com";
      };
      "gvstyle.com" = {
        file = "/etc/bind/zones/gvstyle.com.txt";
        master = true;
        name = "gvstyle.com";
      };
      "gv.style" = {
        file = "/etc/bind/zones/gv.style.txt";
        master = true;
        name = "gv.style";
      };
      "hopgv.org" = {
        file = "/etc/bind/zones/hopgv.org.txt";
        master = true;
        name = "hopgv.org";
      };
      "l14s.com" = {
        file = "/etc/bind/zones/l14s.com.txt";
        master = true;
        name = "l14s.com";
      };
      "lesgrandsvoisins.com" = {
        file = "/etc/bind/zones/lesgrandsvoisins.com.txt";
        master = true;
        name = "lesgrandsvoisins.com";
      };
      "lesgv.com" = {
        file = "/etc/bind/zones/lesgv.com.txt";
        master = true;
        name = "lesgv.com";
      };
      "lesgv.org" = {
        file = "/etc/bind/zones/lesgv.org.txt";
        master = true;
        name = "lesgv.org";
      };
      "lesgvs.com" = {
        file = "/etc/bind/zones/lesgvs.com.txt";
        master = true;
        name = "lesgvs.com";
      };
      "lgv1.com" = {
        file = "/etc/bind/zones/lgv1.com.txt";
        master = true;
        name = "lgv1.com";
      };
      "lgv.info" = {
        file = "/etc/bind/zones/lgv.info.txt";
        master = true;
        name = "lgv.info";
      };
      "libregood.com" = {
        file = "/etc/bind/zones/libregood.com.txt";
        master = true;
        name = "libregood.com";
      };
      "maelanc.com" = {
        file = "/etc/bind/zones/maelanc.com.txt";
        master = true;
        name = "maelanc.com";
      };
      "pargv.com" = {
        file = "/etc/bind/zones/pargv.com.txt";
        master = true;
        name = "pargv.com";
      };
      "paris14.cc" = {
        file = "/etc/bind/zones/paris14.cc.txt";
        master = true;
        name = "paris14.cc";
      };
      "parisgv.com" = {
        file = "/etc/bind/zones/parisgv.com.txt";
        master = true;
        name = "parisgv.com";
      };
      "parisgv.org" = {
        file = "/etc/bind/zones/parisgv.org.txt";
        master = true;
        name = "parisgv.org";
      };
      "parisle.com" = {
        file = "/etc/bind/zones/parisle.com.txt";
        master = true;
        name = "parisle.com";
      };
      "parislenuage.com" = {
        file = "/etc/bind/zones/parislenuage.com.txt";
        master = true;
        name = "parislenuage.com";
      };
      "parisle.org" = {
        file = "/etc/bind/zones/parisle.org.txt";
        master = true;
        name = "parisle.org";
      };
      "quiquequoi.com" = {
        file = "/etc/bind/zones/quiquequoi.com.txt";
        master = true;
        name = "quiquequoi.com";
      };
      "quiquoietc.com" = {
        file = "/etc/bind/zones/quiquoietc.com.txt";
        master = true;
        name = "quiquoietc.com";
      };
      "resdigita.com" = {
        file = "/etc/bind/zones/resdigita.com.txt";
        master = true;
        name = "resdigita.com";
      };
      "whowhatetc.com" = {
        file = "/etc/bind/zones/whowhatetc.com.txt";
        master = true;
        name = "whowhatetc.com";
      };
      "yanlomsprod.org" = {
        file = "/etc/bind/zones/yanlomsprod.org.txt";
        master = true;
        name = "yanlomsprod.org";
      };
    };
  };
}
