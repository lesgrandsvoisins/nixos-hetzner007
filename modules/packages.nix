{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  imports = [
    ./packages/vim.nix
    ./packages/common.nix
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # homarr
    nixos-container
    # pocketbase
    nftables

    # ghost-cli

    htop
    pnpm
    bottom
    coreutils
    findutils # locate
    jq
    killall
    mosh
    procs
    tree
    dust # dust
    ripgrep # rg
    sd # sed alternative
    fx # pour json
    httpie
    nil # nix
    shellcheck
    shfmt
    statix

    caddy
    nss

    keeweb
  ];
}
