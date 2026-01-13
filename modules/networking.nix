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
