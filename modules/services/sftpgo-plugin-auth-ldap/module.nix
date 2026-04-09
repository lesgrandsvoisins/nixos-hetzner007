{
  pkgs ? import <nixpkgs> {},
  config ? {},
  lib ? pkgs.lib,
  ...
}: let
  cfg = config.services.sftpgo-plugin-auth;
in {
  options.services.sftpgo-plugin-auth = {
    enable = lib.mkEnableOption "SFTPGo LDAP auth plugin";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {};
      description = "Package to use for the plugin";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = ''
        Environment variables for the plugin.
        See upstream docs for SFTPGO_PLUGIN_AUTH_* variables.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.sftpgo-plugin-auth = {
      description = "SFTPGo LDAP auth plugin";
      after = ["network.target"];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/sftpgo-plugin-auth serve";
        Restart = "always";

        # Hardening (optional but nice)
        DynamicUser = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
      };

      environment = cfg.settings;
      wantedBy = ["multi-user.target"];
    };
  };
}
