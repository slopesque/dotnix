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
      url = "github:slopesque/hypryaml/develop";
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
          ./modules/nixos
          ./overlays
          ./users
        ];
      };

      lib = import ./lib {
        inherit nixpkgs;
        defaultSystems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };

      perSystemDefs = lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          bravePkgs = pkgs.callPackage ./pkgs/brave { };
        in
        {
          devShells.default = pkgs.callPackage ./shell.nix { };
          formatter = pkgs.nixfmt;
          packages = { inherit (bravePkgs) brave brave-origin; };
        }
      );
    in
    {
      inherit lib;
      inherit (perSystemDefs) devShells formatter packages;
      nixosConfigurations = import ./configurations/nixos allInputs;
    };
}
