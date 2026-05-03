{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  users.users."guichet" = {
    isNormalUser = true;
    extraGroups = ["wwwrun"];
    uid = vars.uid.guichet;
    group = "wwwrun";
  };
  systemd.services.guichet = {
    enable = true;
    wantedBy = ["default.target"];
    script = "/home/guichet/guichet/guichet";
    description = "Guichet, Self-Service LDAP account admin";
    serviceConfig = {
      WorkingDirectory = "/home/guichet/guichet";
      User = "guichet";
      Group = "wwwrun";
    };
  };
  systemd.services.newguichet = {
    enable = true;
    wantedBy = ["default.target"];
    script = "/home/guichet/newguichet/backend/guichet serve --publicDir ../frontend/build";
    description = "Guichet, Self-Service LDAP account admin";
    serviceConfig = {
      WorkingDirectory = "/home/guichet/newguichet/backend";
      User = "guichet";
      Group = "wwwrun";
    };
  };

  systemd.timers."guichet-wwwrun-fix-perms" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnUnitActiveSec = "5m";
      Unit = "guichet-wwwrun-fix-perms.service";
    };
  };
  systemd.timers."restart-email" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnUnitActiveSec = "45m";
      Unit = "restart-email.service";
    };
  };
  systemd.services."restart-email" = {
    script = ''
      set -eu
      ${pkgs.systemd}/bin/systemctl restart guichet openldap postfix dovecot
    '';
    # script = ''
    #   set -eu
    #   ${pkgs.systemd}/bin/systemctl restart guichet openldap postfix dovecot2
    # '';
    serviceConfig = {
      User = "root";
    };
  };
  systemd.services."guichet-wwwrun-fix-perms" = {
    script = ''
      set -eu
      ${pkgs.coreutils}/bin/chown -R wwwrun:users /var/www/{secret,dav}
      ${pkgs.coreutils}/bin/chown -R guichet:wwwrun /home/guichet/guichet/static
      ${pkgs.coreutils}/bin/chmod -R g+w /var/www/{secret,dav}
    '';
    serviceConfig = {
      User = "root";
    };
  };
}
