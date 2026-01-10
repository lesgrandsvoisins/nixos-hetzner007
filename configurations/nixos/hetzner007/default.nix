{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  nixos-unified.sshTarget = "mannchri@hetzner007.grandsvoisins.com";

  imports = [
    self.nixosModules.default
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen4

    ./configuration.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  # boot.initrd.kernelModules = [ "amdgpu" ];
  # services.tailscale.enable = true;
}
