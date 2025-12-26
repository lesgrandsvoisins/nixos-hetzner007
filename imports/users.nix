
{ config, pkgs, ... }:
let
in
{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mannchri = {
    isNormalUser = true;
    description = "mannchri";
    extraGroups = [ "networkmanager" "wheel" "acme" "caddy" ];
    packages = with pkgs; [];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dashy = {
    isNormalUser = true;
    description = "dash";
    extraGroups = [ "caddy" ];
    packages = with pkgs; [];
  };
}