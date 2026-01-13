{
  config,
  pkgs,
  ...
}: let
  vars = import ../vars.nix;
  # external-mac = "90:1b:0e:9e:ec:37";
  # ext-if = "enx901b0e9eec37";
  # external-ip = "213.239.216.138";
  # external-gw = "213.239.216.159";
  # external-netmask = "27";
  # external2-ip = "213.239.217.187";
  # external2-gw = "213.239.217.161";
  # external2-netmask = "27";
  # external-ip6 = "2a01:4f8:a0:73ba::";
  # external-gw6 = "fe80::1";
  # external-netmask6 = "64";
in {
  imports = [
    ./networking/firewall.nix
  ];
  systemd.network = {
    enable = true;
  };
  networking = {
    hostName = "hetzner007";
    domain = "grandsvoisins.org";
    useNetworkd = true;
    enableIPv6 = true;
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    interfaces.eth0 = {
      useDHCP = true;
      ipv6 = {
        addresses = [
          {
            address = (builtins.elemAt vars.hetzner.ipv6 0).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 0).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 1).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 1).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 2).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 2).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 3).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 3).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 4).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 4).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 5).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 5).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 6).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 6).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 7).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 7).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 8).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 8).netmask;
          }
          {
            address = (builtins.elemAt vars.hetzner.ipv6 9).addr;
            prefixLength = (builtins.elemAt vars.hetzner.ipv6 9).netmask;
          }
        ];
      };
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-*"];
      externalInterface = "eth0";
      enableIPv6 = true;
    };
  };
}
