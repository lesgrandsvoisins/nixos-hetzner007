
{ config, pkgs, ... }:
let
in
{
  imports = [
    ./packages/vim.nix
    ./packages/common.nix
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # homarr
  ];
}