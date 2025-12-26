
{ config, pkgs, ... }:
let
in
{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mannchri = {
    isNormalUser = true;
    description = "mannchri";
    extraGroups = [ "networkmanager" "wheel" "acme" ];
    packages = with pkgs; [];
  };
}