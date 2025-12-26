# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
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
in
{
  nix.settings.experimental-features = "nix-command flakes";
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./imports/networking.nix
      ./imports/security.nix
      ./imports/users.nix
      ./imports/packages.nix
      ./imports/services.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };


  # Configure console keymap
  console.keyMap = "fr";



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
