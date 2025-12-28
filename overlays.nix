# overlays.nix
# This module defines an overlay to add packages from nixpkgs-unstable.
{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true; # Also allow unfree packages from unstable
      };
      homarr = prev.callPackage derivations/homarr/package.nix {};
    })
  ];
}