{
  inputs.sync-in.url = "path:./.";

  outputs = {
    self,
    nixpkgs,
    sync-in,
    ...
  }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        sync-in.nixosModules.sync-in

        {
          services.sync-in = {
            enable = true;

            admin.passwordFile = "/run/secrets/admin";
            database.passwordFile = "/run/secrets/db";
          };
        }
      ];
    };
  };
}
