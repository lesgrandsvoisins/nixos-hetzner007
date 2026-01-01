{
  config,
  pkgs,
  ...
}: let
  external-mac = "90:1b:0e:9e:ec:37";
  ext-if = "enx901b0e9eec37";
  external-ip = "213.239.216.138";
  external-gw = "213.239.216.159";
  external-netmask = "27";
  external2-ip = "213.239.217.187";
  external2-gw = "213.239.217.161";
  external2-netmask = "27";
  external-ip6 = "2a01:4f8:a0:73ba::";
  external-gw6 = "fe80::1";
  external-netmask6 = "64";
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 25 53 80 443 636];
    allowedUDPPorts = [53];
    filterForward = true;
    extraCommands = ''
      nftables -t nat -A POSTROUTING --sport 636 -p tcp -m tcp --dport 3636 -j MASQUERADE";
    '';
  };
  networking.nftables = {
    enable = true;
  };
}
