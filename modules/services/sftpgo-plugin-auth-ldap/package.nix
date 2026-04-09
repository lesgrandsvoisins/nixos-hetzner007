{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  buildGoModule ? pkgs.buildGoModule,
  fetchFromGitHub ? pkgs.fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sftpgo-plugin-auth";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "sftpgo";
    repo = "sftpgo-plugin-auth";
    rev = "v${version}";
    hash = "sha256-YuHH6gmMwLtvgt3eYABEAiTZoYudJ5vrPqYD3csUDbc=";
  };

  doCheck = false;

  vendorHash = "sha256-eq6DTpxqHlybS8Eyy7e35LClakSh4D7i/UoZaSpsytk=";

  meta = with lib; {
    description = "LDAP/Active Directory authentication plugin for SFTPGo";
    homepage = "https://github.com/sftpgo/sftpgo-plugin-auth";
    license = licenses.agpl3Only;
    maintainers = [];
  };
}
