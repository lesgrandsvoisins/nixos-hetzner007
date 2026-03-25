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
    allowedTCPPorts = [
      22
      25
      53
      80
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
    ];
    # interfaces."ve-homarr@if2".allowedTCPPorts = [vars.ports.homarr];
    extraInputRules = ''
      ip daddr ${builtins.toString vars.hosts.node-red.ipv4}/24 tcp dport ${builtins.toString vars.ports.node-red} accept
      ip6 daddr ${builtins.toString vars.hosts.node-red.ipv6}/96 tcp dport ${builtins.toString vars.ports.node-red} accept
      ip daddr ${builtins.toString vars.hosts.homarr.ipv4}/24 tcp dport ${builtins.toString vars.ports.homarr} accept
      ip6 daddr ${builtins.toString vars.hosts.homarr.ipv6}/96 tcp dport ${builtins.toString vars.ports.homarr} accept
    '';
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
