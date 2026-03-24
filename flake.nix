{
  description = "A flake for a pretty nice NixOS configuration.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:mccreemainwoody/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypryaml = {
      url = "github:mccreemainwoody/hypryaml";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mediatek-m6639-module = {
      url = "github:clemenscodes/linux-mediatek-mt6639-bluetooth-kernel-module";
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
