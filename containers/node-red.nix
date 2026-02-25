{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # vars = import ../vars.nix;
in {
  users = {
    users.node-red = {
      extraGroups = ["services"];
      uid = vars.uid.node-red;
    };
    groups.node-red.gid = vars.gid.node-red;
  };
  networking.hosts = {
    "${vars.hosts.node-red.ipv4}" = ["node-red.local"];
  };
  systemd.tmpfiles.rules = [
    "d /etc/node-red 0775 node-red services"
    # "f /etc/node-red/node-red.local.pem 0664 node-red services"
    # "f /etc/node-red/node-red.local-key.pem 0640 node-red services"
  ];
  systemd.services.node-red-init = {
  };
  containers.node-red = {
    localAddress = vars.hosts.node-red.ipv4;
    localAddress6 = vars.hosts.node-red.ipv6;
    hostAddress = "10.0.13.1";
    hostAddress6 = "fa13::1";
    privateNetwork = true; # ve-wiki-js-www
    bindMounts = {
      "/etc/red-node" = {
        hostPath = "/etc/red-node";
        isReadOnly = true;
      };
    };
    config = {
      systemd.tmpfiles.rules = [
        "d /etc/node-red 0775 node-red services"
        # "f /etc/node-red/node-red.local.pem 0664 node-red services"
        # "f /etc/node-red/node-red.local-key.pem 0640 node-red services"
      ];
      system.stateVersion = "25.11";
      imports = [../modules/common.nix];
      environment.systemPackages = with pkgs; [
        git
        bash
      ];
      environment = {
        # environment variables are removed, so we need to specify nix-ld environment here
        NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
        NIX_LD_LIBRARY_PATH = with pkgs;
          lib.makeLibraryPath [
            # List by default
            zlib
            zstd
            stdenv.cc.cc
            curl
            openssl
            attr
            libssh
            bzip2
            libxml2
            acl
            libsodium
            util-linux
            xz
            systemd
          ];
      };

      networking.hosts = {
        "${vars.hosts.node-red.ipv4}" = ["node-red.local"];
      };
      users = {
        users.node-red = {
          extraGroups = ["services"];
          uid = vars.uid.node-red;
        };
        groups.node-red.gid = vars.gid.node-red;
        groups.services.gid = vars.gid.services;
      };
      system.services.node-red = {
        enable = true;
        port = vars.ports.node-red;
        configFile = ./node-red/node-red-settings.js;
        withNpmAndGcc = true; # Allow imperative download of nodes. Need to enable nix-ld
      };
      systemd.services.node-red-initssl = {
        enable = true;
        enableDefaultPath = true;
        wantedBy = ["multi-user.target"];
        unitConfig = {
          Description = ''
            Creating of /etc/node-red/red-node.local{,-key}.pem files
          '';
        };
        serviceConfig = {
          User = "node-red";
          Group = "services";
          ExecStart = "/run/current-system/sw/bin/mkcert red-node.local";
          WorkingDirectory = "/etc/node-red";
          Type = "oneshot";
        };
      };
    };
  };
}
