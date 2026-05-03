{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  vars,
  zensical,
  ...
}: let
in {
  imports = [
    ./packages/vim.nix
    ./packages/common.nix
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    zensical.packages.${pkgs.stdenv.hostPlatform.system}.zensical
    # pkgs.homarr
    pkgs.nixos-container
    # pkgs.pocketbase
    pkgs.nftables

    # pkgs.ghost-cli

    pkgs.htop
    pkgs.pnpm
    pkgs.bottom
    pkgs.coreutils
    pkgs.findutils # locate
    pkgs.jq
    pkgs.killall
    pkgs.mosh
    pkgs.procs
    pkgs.tree
    pkgs.dust # dust
    pkgs.ripgrep # rg
    pkgs.sd # sed alternative
    pkgs.fx # pour json
    pkgs.httpie
    pkgs.nil # nix
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.statix

    pkgs.caddy
    pkgs.nss

    # pkgs.keeweb
    pkgs.jq
    pkgs.mdadm

    pkgs.btrfs-progs
  ];
}
