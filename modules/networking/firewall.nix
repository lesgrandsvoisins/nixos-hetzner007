{
  pkgs,
  lib,
  config,
  vars,
  ...
}:
let
in
{
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
      3636
    ];
    allowedUDPPorts = [ 53 ];
    # filterForward = true;
    # extraCommands = ''
    #   nftables -t nat -A POSTROUTING --sport 636 -p tcp -m tcp --dport 3636 -j MASQUERADE";
    # '';
  };
  networking.nat = {
    enable = true;
    externalIPv6 = (builtins.elemAt vars.hetzner.ipv6 0).addr;
    externalIP = (builtins.elemAt vars.hetzner.ipv4 0).addr;
    enableIPv6 = true;
    externalInterface = vars.hetzner.interface;
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
