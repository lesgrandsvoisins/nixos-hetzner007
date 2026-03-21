{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/homarr2/certs 0755 homarr services"
  ];
  containers.homarr2 = {
    bindMounts = {
      "/etc/homarr2/" = {
        hostPath = "/etc/homarr2/";
        isReadOnly = true;
      };
    };
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.205.10";
    localAddress = "192.168.205.11";
    hostAddress6 = "fa02::1";
    localAddress6 = "fa02::2";
    # hostAddress6 = "2a01:4f8:241:4faa::10";
    # localAddress6 = "2a01:4f8:241:4faa::11";
    config = {
      system.stateVersion = "25.11";
      nix.settings.experimental-features = "nix-command flakes";
      imports = [
        ../modules/packages/common.nix
        ../modules/packages/vim.nix
      ];
      environment.systemPackages = with pkgs; [
        nodejs_24
        pnpm_9
        pnpmConfigHook
      ];
      networking = {
        hostName = "homarr2";
        domain = "homarr2.gv.je";
        hosts = {
          "fa02::2" = ["homarr2.local"];
        };
        useHostResolvConf = false;
        interfaces."eth0".useDHCP = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            80
            443
          ];
        };
        # interfaces.eth0 = {
        #   ipv6 = {
        #     addresses = [
        #       {
        #         address = (builtins.elemAt vars.hetzner.ipv6 9).addr;
        #         prefixLength = (builtins.elemAt vars.hetzner.ipv6 9).netmask;
        #       }
        #     ];
        #   };
        # };
      };
      systemd.tmpfiles.rules = [
        "d /etc/homarr2/certs 0755 homarr2 services"
      ];
      users.users.homarr = {
        uid = vars.uid.homarr;
        group = "services";
        isSystemUser = true;
      };
      users.groups.services.gid = vars.gid.services;

      services = {
        resolved = {
          enable = true;
        };
      };
    };
  };
}
