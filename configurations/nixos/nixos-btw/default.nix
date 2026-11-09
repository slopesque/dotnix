{
  nixpkgs,
  modules,
  ...
}@inputs:
let
  system = "x86_64-linux";
in
nixpkgs.lib.nixosSystem {
  system = system;
  specialArgs = { inherit inputs system; };
  modules = modules ++ [ ./configuration.nix ];
}
