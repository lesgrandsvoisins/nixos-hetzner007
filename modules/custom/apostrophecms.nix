{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  users.users.aaa = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
    packages = with pkgs; [nodejs_20];
    uid = vars.uid.aaa;
  };
}
