{ config, pkgs, ... }:
let
in
{
  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
#     acme-dns = {
#       enable = true;
#       settings = {
#         
#       };
#     };
#     nginx = {
#       enable = true;
#       virtualHosts = {
#         "hetzner007.gdvoisins.com" = {
#           forceSSL = true;
#           enableACME = true;
#         };
#       };
#     };
  };
}