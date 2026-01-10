{
  pkgs,
  lib,
  vars,
  ...
}: let
  external-mac = (builtins.elemAt vars.hetzner.interfaces 0).mac;
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
  imports = [
    ./networking/firewall.nix
  ];
  networking = {
    hostName = "whowhatetc"; # Define your hostname.
    usePredictableInterfaceNames = false;
    #   systemd.network = {
    #     enable = true;
    #     networks."${ext-if}".extraConfig = ''
    #       [Match]
    #       Name = ${ext-if}
    #       [Network]
    #       # Add your own assigned ipv6 subnet here here!
    #       Address = ${external-ip6}/64
    #       Gateway = ${external-gw6}
    #       # optionally you can do the same for ipv4 and disable DHCP (networking.dhcpcd.enable = false;)
    #       # Address = ${external-ip}/${external-netmask}
    #       # Gateway = ${external-gw}
    #     '';
    #   };
    # dhcpcd.enable = false;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    # networkmanager.enable = true;
    # services.udev.extraRules = ''SUBSYSTEM=="net", ATTR{address}=="${external-mac}", NAME="${ext-if}"'';
    #networking = {
    #  interfaces."${ext-if}" = {
    #    ipv4.addresses = [
    #    {
    #      address = external-ip;
    #      prefixLength = external-netmask;
    #     }
    #    ];
    #    ipv6.addresses = [{
    #      address = external-ip6;
    #      prefixLength = external-netmask6;
    #    }];
    #  };
    #  defaultGateway6 = {
    #    address = external-gw6;
    #    interface = ext-if;
    #  };
    #  defaultGateway = external-gw;
    #};
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
  };
}
