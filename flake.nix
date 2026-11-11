{
  description = "A flake for a pretty nice personal Nix ecosystem.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    hyprnix = {
      url = "github:hyprwm/hyprnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:slopesque/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      hyprnix,
      ...
    }@inputs:
    let
      hyprlandOverlay = {
        nixpkgs.overlays = [ hyprnix.overlays.hyprland ];
      };

      allInputs = inputs // {
        modules = [
          home-manager.nixosModules.home-manager
          hyprlandOverlay
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
      nixOnDroidConfigurations = import ./configurations/nix-on-droid allInputs;
    };
}
