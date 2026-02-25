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
      # extraGroups = ["services"];
      group = "services";
      uid = vars.uid.node-red;
      isSystemUser = true;
    };

    # groups.node-red.gid = vars.gid.node-red;
    # groups.node-red.gid = vars.gid.node-red;
  };
  networking.hosts = {
    "${vars.hosts.node-red.ipv4}" = ["node-red.local"];
  };
  systemd.tmpfiles.rules = [
    "d /etc/node-red 0775 node-red services"
    # "f /etc/node-red/node-red.local.pem 0664 node-red services"
    # "f /etc/node-red/node-red.local-key.pem 0640 node-red services"
  ];
  # systemd.services.node-red-init = {
  # };

  systemd.services.node-red-initssl = {
    enable = true;
    # enableDefaultPath = true;
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
    autoStart = true;

    config = {
      system.stateVersion = "25.11";
      nix.settings.experimental-features = "nix-command flakes";
      imports = [
        ../modules/packages/common.nix
        ../modules/packages/vim.nix
      ];
      systemd.tmpfiles.rules = [
        "d /etc/node-red 0775 node-red services"
        # "f /etc/node-red/node-red.local.pem 0664 node-red services"
        # "f /etc/node-red/node-red.local-key.pem 0640 node-red services"
      ];
      # system.stateVersion = "25.11";
      # imports = [../modules/packages/common.nix];
      systemd.services.node-red = {
        path = with pkgs; [
          # git is needed for projects, but systemd resets the path so we need to add it back
          git
          # needed by nodejs to install for instance node-red-dashboard (or "error syscall spawn sh")
          bash
          # Add here any other program needed by the npm packages you want to install
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
      };

      networking.hosts = {
        "${vars.hosts.node-red.ipv4}" = ["node-red.local"];
      };
      users = {
        users.node-red = {
          # group = "services";
          extraGroups = ["services"];
          uid = vars.uid.node-red;
        };
        # groups.node-red.gid = vars.gid.node-red;
        groups.services.gid = vars.gid.services;
      };
      services.node-red = {
        enable = true;
        port = vars.ports.node-red;
        configFile = ./node-red/settings.js;
        withNpmAndGcc = true; # Allow imperative download of nodes. Need to enable nix-ld
      };
    };
  };
}
