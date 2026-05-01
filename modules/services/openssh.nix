{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    listenAddresses = [
      {
        addr = "[::]";
        port = 22;
      }
      {
        addr = "0.0.0.0";
        port = 22;
      }
    ];
  };
}
