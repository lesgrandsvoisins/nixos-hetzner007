{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  systemd.tmpfiles.rules = [
    "d /var/www/key.lesgrandsvoisins.com 0755 wwwrun users -"
    "d /var/www/key.resdigita.com 0755 wwwrun users -"
    "d /var/www/keycloak.paris14.cc 0755 wwwrun users -"
    "d /var/www/keycloak.gvois.com 0755 wwwrun users -"
    "d /var/www/lesgrandsvoisins.com 0755 wwwrun users -"
    "d /var/www/grandzine.org_static 0755 wwwrun users -"
    "d /var/www/lesgrandsvoisins 0755 wagtail users -"
    "d /var/www/lesgrandsvoisins/static 0755 wagtail users -"
    "d /var/www/lesgrandsvoisins/medias 0755 wagtail users -"
    "d /var/www/coopgv 0775 wagtail users -"
    "d /var/www/coopgv/static 0775 wagtail users -"
    "d /var/www/coopgv/medias 0775 wagtail users -"
    "d /var/www/grandv 0775 wagtail users -"
    "d /var/www/grandv/static 0775 wagtail users -"
    "d /var/www/grandv/media 0775 wagtail users -"
    "d /var/www/gdvox/static 0775 wagtail users -"
    "d /var/www/gdvox/media 0775 wagtail users -"
    "d /var/www/lesgvorg/static 0775 wagtail users -"
    "d /var/www/lesgvorg/media 0775 wagtail users -"
    "d /run/wagtail-sockets 0770 wagtail wwwrun -"
    "f /run/wagtail-sockets/wagtail.sock 0660 wagtail wwwrun"
    "d /var/www/wagtail.resdigita.com.main 0775 wagtail users -"
    "d /var/www/wagtail.resdigita.com.main/static 0775 wagtail users -"
    "d /var/www/wagtail.resdigita.com.main/media 0775 wagtail users -"
    "d /var/www/wagtail.resdigita.com.develop 0775 wagtail users -"
    "d /var/www/wagtail.resdigita.com.develop/static 0775 wagtail users -"
    "d /var/www/wagtail.resdigita.com.develop/media 0775 wagtail users -"
    # /etc/.secrets/openldap.bind
    "d /etc/.secrets 0750 root services -"
    "f /etc/.secrets/openldap.bind 0640 openldap root -"
  ];
}
