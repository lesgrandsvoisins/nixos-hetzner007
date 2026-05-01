{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  ## ODOO FOR
  users.users.odoofor = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
    uid = vars.uid.odoofor;
  };
  ## ODOO THREE
  users.users.odoothree = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
    uid = vars.uid.odoothree;
  };
  ## ODOO TOO
  users.users.odootoo = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
    uid = vars.uid.odootoo;
  };
  ## ODOO
  users.users.odoo = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [vars.keys.public.mannchri];
    uid = vars.uid.odoo;
  };
}
