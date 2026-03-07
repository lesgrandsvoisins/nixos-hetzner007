{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
  ldapDomainName = vars.domains.ldap;
  ldapBaseDN = vars.ldap.baseDN;
  # bindSlappasswd = import ../secrets/bind.slappasswd;
in {
  systemd.tmpfiles.rules = [
    "d /etc/.secrets/ 0750 root:services"
    "f /etc/.secrets/.cloudns.auth.id 0640 root:services"
    "f /etc/.secrets/.cloudns.auth.password 0640 root:services"
    "f /etc/.secrets/.cloudns.auth.email 0640 root:services"
  ];
  users.users.openldap = {
    uid = vars.uid.openldap;
    group = "services";
  };
  # networking.hosts = {
  #   # "::1" = [ "radicale.local" ];
  #   # "${builtins.elemAt vars.ip6s.hosts 1}" = [ldapDomainName];
  # };
  security.acme.certs."${ldapDomainName}" = {
    dnsProvider = "clouddns";
    # environmentFile = "/etc/.secrets/.cloudns.auth";
    credentialFiles = {
      "CLOUDNS_AUTH_ID_FILE" = "/etc/.secrets/.cloudns.auth.id";
      "CLOUDNS_AUTH_PASSWORD_FILE" = "/etc/.secrets/.cloudns.auth.password";
      "CLOUDNS_AUTH_EMAIL_FILE" = "/etc/.secrets/.cloudns.auth.email";
    };
    group = "services";
  };
  services.cron.systemCronJobs = ["0 0 1 * *  root systemctl restart openldap"];
  services.openldap = {
    enable = true;
    urlList = ["ldap://${ldapDomainName}:14389/ ldaps://${ldapDomainName}:14636/ ldapi:///"];
    group = "services";
    # urlList = ["ldap://${ldapDomainName}:14389/ ldaps://${ldapDomainName}:14636/ ldapi:///"];
    settings = {
      attrs = {
        olcLogLevel = "conns config";
        /*
          tls
        settings for acme ssl
        */
        olcTLSCACertificateFile = "/etc/openldap/.tls/cert.pem";
        olcTLSCertificateFile = "/etc/openldap/.tls/cert.pem";
        olcTLSCertificateKeyFile = "/etc/openldap/.tls/key.pem";
        olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
        olcTLSCRLCheck = "none";
        olcTLSVerifyClient = "never";
        olcTLSProtocolMin = "3.1";
        olcThreads = "16";
      };
      # Flake this
      children = {
        "cn=schema".includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${pkgs.openldap}/etc/schema/nis.ldif"
        ];
        "olcDatabase={1}mdb".attrs = {
          objectClass = ["olcDatabaseConfig" "olcMdbConfig"];
          olcDbIndex = [
            "displayName,description eq,sub"
            "uid,ou,c eq"
            "carLicense,labeledURI,telephoneNumber,mobile,homePhone,title,street,l,st,postalCode eq"
            "objectClass,cn,sn,givenName,mail eq"
          ];
          olcDatabase = "{1}mdb";
          olcDbDirectory = "/var/lib/openldap/data";
          olcSuffix = "${ldapBaseDN}";
          /*
          your admin account, do not use writeText on a production system
          */
          olcRootDN = "cn=admin,${ldapBaseDN}";
          # olcRootPW = "${bindSlappasswd}";
          olcAccess = [
            /*
            custom access rules for userPassword attributes
            */
            /*
            allow read on anything else
            */
            ''              {0}to dn.subtree="ou=newusers,${ldapBaseDN}"
                                    by dn.exact="cn=newuser,ou=users,${ldapBaseDN}" write
                                    by group.exact="cn=administration,ou=groups,${ldapBaseDN}" write
                                    by self write
                                    by anonymous auth
                                    by * read''
            ''              {1}to dn.subtree="ou=invitations,${ldapBaseDN}"
                                    by dn.exact="cn=newuser,ou=users,${ldapBaseDN}" write
                                    by group.exact="cn=administration,ou=groups,${ldapBaseDN}" write
                                    by self write
                                    by anonymous auth
                                    by * read''
            # ''                    {2}to dn.subtree="ou=users,${ldapBaseDN}"
            ''              {2}to dn.subtree="${ldapBaseDN}"
                                    by dn.exact="cn=admin@lesgrandsvoisins.com,ou=users,${ldapBaseDN}" manage
                                    by dn.exact="cn=newuser,ou=users,${ldapBaseDN}" write
                                    by dn.exact="uid=reader,ou=users,${ldapBaseDN}" read
                                    by group.exact="cn=administration,ou=groups,${ldapBaseDN}" write
                                    by self write
                                    by anonymous auth
                                    by * read''
            ''              {3}to attrs=userPassword
                                    by dn.exact="cn=admin@lesgrandsvoisins.com,ou=users,${ldapBaseDN}" manage
                                    by self write
                                    by anonymous auth
                                    by * none''
            ''              {4}to *
                                    by dn.exact="cn=sogo@lesgrandsvoisins.com,ou=users,${ldapBaseDN}" manage
                                    by dn.exact="cn=chris@lesgrandsvoisins.com,ou=users,${ldapBaseDN}" manage
                                    by dn.exact="cn=chris@mann.fr,ou=users,${ldapBaseDN}" manage
                                    by dn.exact="cn=admin@lesgrandsvoisins.com,ou=users,${ldapBaseDN}" manage
                                    by self write
                                    by anonymous auth''
            /*
            custom access rules for userPassword attributes
            */
            ''              {5}to attrs=cn,sn,givenName,displayName,member,memberof
                                    by self write
                                    by * read''
            ''              {6}to *
                                    by * read''
          ];
        };
      };
    };
  };
}
