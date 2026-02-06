{
  description = "NixOS (COSMIC + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/common.nix
          ./hosts/laptop/default.nix
          ./hosts/laptop/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.takashi = import ./home/takashi.nix;
          }
        ];
      };

      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/common.nix
          ./hosts/vm/default.nix
          ./hosts/vm/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.takashi = import ./home/takashi.nix;
          }
        ];
      };
    };
}
