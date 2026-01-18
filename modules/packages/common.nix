{
  config,
  pkgs,
  libs,
  vars,
  ...
}: let
in {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    dig
    git
    gnumake
    inetutils
    killall
    lynx
    lzlib
    openldap
    openssl
    pwgen
    python3
    tmux
    uv
    wget
    net-tools
    unzip
    mkcert
  ];
}
