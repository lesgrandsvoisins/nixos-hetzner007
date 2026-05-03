{
  config,
  pkgs,
  libs,
  vars,
  ...
}: let
in {
  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "hostmaster@lesgrandsvoisins.com";
      };
    };
  };
}
