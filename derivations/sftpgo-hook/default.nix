{pkgs ? import <nixpkgs> {}}: let
  vars = import ../../vars.nix;
in
  pkgs.writeShellApplication {
    name = "sftpgo-prelogin-hook";
    runtimeInputs = [pkgs.jq pkgs.coreutils pkgs.findutils pkgs.gnugrep];
    text = ''
        set -euo pipefail

      # Configurable base directory for user homes
      HOME_BASE="''${SFTPGO_HOME_BASE:-${vars.dirs.sftpgo-users}}"

      # Optional ownership/perms (useful if SFTPGo runs as root)
      # If not set, the script will not chown (but will still mkdir).
      OWNER_UID="''${SFTPGO_HOME_UID:-${builtins.toString vars.uid.sftpgo}}"
      OWNER_GID="''${SFTPGO_HOME_GID:-${builtins.toString vars.gid.sftpgo}}"
      HOME_MODE="''${SFTPGO_HOME_MODE:-0750}"

      if [ -z "''${SFTPGO_LOGIND_USER:-}" ]; then
        echo "SFTPGO_LOGIND_USER is not set" >&2
        exit 1
      fi

      USER_JSON="$SFTPGO_LOGIND_USER"
      USERNAME="$(printf '%s' "$USER_JSON" | jq -r '.username // empty')"

      if [ -z "$USERNAME" ] || [ "$USERNAME" = "null" ]; then
        echo "Could not extract .username from SFTPGO_LOGIND_USER" >&2
        exit 1
      fi

      # Basic safety: avoid path traversal / weird names becoming directories
      # (adjust allowed set if your usernames differ)
      if ! printf '%s' "$USERNAME" | grep -Eq '^[A-Za-z0-9._@-]+$'; then
        echo "Refusing unsafe username: $USERNAME" >&2
        exit 1
      fi

      HOME_DIR="$HOME_BASE/$USERNAME"

      # Create home dir (and parents)
      mkdir -p "$HOME_DIR"
      chmod "$HOME_MODE" "$HOME_DIR"

      # If running with permissions, set ownership
      if [ -n "$OWNER_UID" ] && [ -n "$OWNER_GID" ]; then
        # If not privileged, this will fail; fail fast so you notice misconfig.
        chown "$OWNER_UID:$OWNER_GID" "$HOME_DIR"
      fi

      # Emit user JSON for SFTPGo
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
  }
