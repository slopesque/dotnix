{
  nixpkgs,
  modules,
  mt7927-nixos,
  ...
}@inputs:
let
  system = "x86_64-linux";
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = { inherit inputs system; };
  modules = modules ++ [
    mt7927-nixos.nixosModules.default
    ./configuration.nix
  ];
}
