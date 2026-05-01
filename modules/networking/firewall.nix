{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  networking.firewall = {
    enable = true;
    # package = pkgs.nftables;
    # # trustedInterfaces = ["docker0" "lxdbr1" "lxdbr0" "ve-silverbullet" "ve-openldap" "ve-key" "lo"];
    # interfaces."ve-key-postgres".allowedTCPPorts = [5432];
    allowedTCPPorts = [
      22
      25
      53
      80
      143 # Hetzner005
      88 # Keycloak Forward
      389
      443
      444 # Keycloak Forward
      587
      636
      vars.ports.node-red # should be in extraInputRules and not here
      vars.ports.homarr # should be in extraInputRules and not here
      3636
      5232
      vars.ports.wiki-js-libregood-https
      vars.ports.wiki-js-libregood-http
      993 # from Hetzner005
      995 # from Hetzner005
      1360 # from Hetzner005
      4443 # from Hetzner005
      4444 # from Hetzner005
      8384 # from Hetzner005
      8443 # from Hetzner005
      9080 # from Hetzner005
      9443 # from Hetzner005
      10080 # from Hetzner005
      10389 # from Hetzner005
      10443 # from Hetzner005
      10636 # from Hetzner005
      11211 # from Hetzner005
      11443 # from Hetzner005
      11447 # from Hetzner005
      12080 # from Hetzner005
      12443 # from Hetzner005
      14389 # from Hetzner005
      14443 # from Hetzner005
      14636 # from Hetzner005
      20000 # from Hetzner005
      21027 # from Hetzner005
      22000 # from Hetzner005
      41443 # from Hetzner005
    ];
    # interfaces."ve-homarr@if2".allowedTCPPorts = [vars.ports.homarr];
    trustedInterfaces = ["ve-homarr" "ve-homarr@if2" "ve-node-red"];
    extraInputRules = ''
      ip daddr ${builtins.toString vars.hosts.node-red.ipv4}/24 tcp dport ${builtins.toString vars.ports.node-red} accept
      ip6 daddr ${builtins.toString vars.hosts.node-red.ipv6}/96 tcp dport ${builtins.toString vars.ports.node-red} accept
    '';
    # TODO MUST BE ADJUSTED FROM HETZNER005
    extraForwardRules = ''
      ip6 saddr 2a01:4f8:241:4faa::10 tcp dnat to fa01::2
    '';

    #   ip daddr ${builtins.toString vars.containers.homarr.network.ipv4.local}/24 tcp dport ${builtins.toString vars.ports.homarr} accept
    #   ip6 daddr ${builtins.toString vars.containers.homarr.network.ipv6.local}/96 tcp dport ${builtins.toString vars.ports.homarr} accept
    # '';
    allowedUDPPorts = [53];
    # filterForward = true;
    # extraCommands = ''
    #   nftables -t nat -A POSTROUTING --sport 636 -p tcp -m tcp --dport 3636 -j MASQUERADE";
    # '';
  };
  networking.nat = {
    enable = true;
    # externalIPv6 = (builtins.elemAt vars.hetzner.ipv6 0).addr;
    externalIP = (builtins.elemAt vars.hetzner.ipv4 0).addr;
    # enableIPv6 = true;
    # externalInterface = "br0";
    # externalInterface = vars.hetzner.interface;
    forwardPorts = [
      {
        sourcePort = 636;
        proto = "tcp";
        destination = "[::]:${builtins.toString vars.ports.lldap-ldaps}";
      }
    ];
  };
  networking.nftables = {
    enable = true;
    #   "natlldap" = {
    #     enable = true;
    #     family = "inet";
    #     content = ''
    #       chain prerouting {{
    #         type nat hook prerouting priority -100; policy accept;
    #         ip daddr 10.1.1.1 tcp dport { 8888 } dnat to 10.2.2.2:9999
    #       }
    #       chain postrouting {
    #         type nat hook postrouting priority 100; policy accept;
    #         masquerade
    #       }
    #     '';
    #   };
  };
}
