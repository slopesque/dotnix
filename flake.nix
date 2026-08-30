{
  description = "A flake for a pretty nice NixOS configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:slopesque/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypryaml = {
      url = "github:slopesque/hypryaml";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mt7927-nixos = {
      url = "github:slopesque/mt7927-nixos/main_custom";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      allInputs = inputs // {
        modules = [
          home-manager.nixosModules.home-manager
          ./modules
          ./overlays
          ./users
        ];
      };

      devSystem = "x86_64-linux";
    in
    {
      formatter.${devSystem} = nixpkgs.legacyPackages.${devSystem}.nixfmt;
      nixosConfigurations = import ./configurations allInputs;
    };
}
