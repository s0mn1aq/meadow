# flake.nix — точка входа всей системы. Здесь объявляются внешние зависимости (inputs) и то, что из них собирается (outputs).
{
  description = "meadow — минимальная и стабильная, декларативная и репродуктивная система на базе NixOS";

  # --- Внешние зависимости, которые Nix скачает и зафиксирует в flake.lock ---
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # --- Что именно собирается из объявленных выше входов ---
  outputs = { nixpkgs, home-manager, ... }@inputs:
  {
    nixosConfigurations.meadow = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/meadow/configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
