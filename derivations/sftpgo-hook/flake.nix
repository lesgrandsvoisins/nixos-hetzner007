{
  description = "SFTPGo pre-login hook (OIDC passwordless)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        vars = import ../../vars.nix;
      in {
        default = pkgs.writeShellApplication {
          name = "sftpgo-prelogin-hook";
          runtimeInputs = [pkgs.jq pkgs.coreutils];
          text = ''
            set -euo pipefail

            if [ -z "''${SFTPGO_LOGIND_USER:-}" ]; then
              echo "SFTPGO_LOGIND_USER is not set" >&2
              exit 1
            fi

            USER_JSON="$SFTPGO_LOGIND_USER"
            USERNAME="$(printf '%s' "$USER_JSON" | ${pkgs.jq}/bin/jq -r '.username // empty')"

            if [ -z "$USERNAME" ] || [ "$USERNAME" = "null" ]; then
              echo "Could not extract .username from SFTPGO_LOGIND_USER" >&2
              exit 1
            fi

            HOME_DIR="${vars.dirs.sftpgo-users}/$USERNAME"

            cat <<EOF
            {
              "status": 1,
              "username": "$USERNAME",
              "home_dir": "$HOME_DIR",
              "permissions": {
                "/": ["list", "download", "upload", "rename", "delete", "create_dirs"]
              },
              "filesystem": {
                "provider": 0,
                "osconfig": {}
              }
            }
            EOF
          '';
        };
      }
    );
  };
}
