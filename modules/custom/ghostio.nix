{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  ghostTemplate = pkgs.callPackage ../../derivations/ghost-lgv-headline/package.nix {};
in {
  systemd.tmpfiles.rules = [
    "L+ ${ghostTemplate} - - - - /var/www/ghost/content/themes/lgv-headline"
  ];
  users.users.ghostio = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
    extraGroups = ["wwwrun"];
    uid = vars.uid.ghostio;
  };
  systemd.services.ghostio = {
    enable = true;
    description = "Ghost systemd service for blog.lesgrandsvoisins.fr: localhost";
    environment = {
      NODE_ENV = "production";
    };
    documentation = ["https://ghost.org/docs/"];
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/var/www/ghost";
      User = "ghost";
      ExecStart = "/home/ghost/.nix-profile/bin/node /home/ghost/node_modules/ghost-cli/bin/ghost run";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };
  systemd.services.ghostlesgrandsvoisinscom = {
    enable = true;
    description = "Ghost systemd service for blog.lesgrandsvoisins.com: localhost";
    environment = {
      NODE_ENV = "production";
    };
    documentation = ["https://ghost.org/docs/"];
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/var/www/ghostlesgrandsvoisinscom";
      User = "ghost";
      ExecStart = "/home/ghost/.nix-profile/bin/node /home/ghost/node_modules/ghost-cli/bin/ghost run";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };
  systemd.services.ghostresdigitacom = {
    enable = true;
    description = "Ghost systemd service for ghost.resdigita.com: localhost";
    environment = {
      NODE_ENV = "production";
    };
    documentation = ["https://ghost.org/docs/"];
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/var/www/ghostresdigitacom";
      User = "ghost";
      ExecStart = "/home/ghost/.nix-profile/bin/node /home/ghost/node_modules/ghost-cli/bin/ghost run";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };
  users.users.ghost = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
    extraGroups = ["wwwrun"];
    packages = with pkgs; [
      nodejs_20
      # nodejs_18
    ];
    uid = vars.uid.ghost;
  };
  services.mysql = {
    ensureDatabases = [
      "ghost"
      "ghostlesgrandsvoisinscom"
      "ghostresdigitacom"
    ];
    ensureUsers = [
      {
        name = "gvoisin";
        ensurePermissions = {
          "ghost.*" = "ALL PRIVILEGES";
          "gvoisin.*" = "ALL PRIVILEGES";
          "ghostlesgrandsvoisinscom.*" = "ALL PRIVILEGES";
          "ghostresdigitacom.*" = "ALL PRIVILEGES";
          # "*.*" = "SELECT, LOCK TABLES, SHOW VIEW, RELOAD";
        };
      }
      {
        name = "ghostlesgrandsvoisinscom";
        ensurePermissions = {
          "ghostlesgrandsvoisinscom.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "ghostresdigitacom";
        ensurePermissions = {
          "ghostresdigitacom.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
