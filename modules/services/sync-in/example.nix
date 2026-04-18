{
  inputs.sync-in.url = "github:your-org/sync-in-nix";

  outputs = {
    self,
    nixpkgs,
    sync-in,
    ...
  }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        sync-in.nixosModules.sync-in

        {
          services.sync-in = {
            enable = true;
            port = 8080;
            dataDir = "/var/lib/sync-in";
          };
        }
      ];
    };
  };
}
