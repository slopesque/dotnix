{
  nixpkgs,
  defaultSystems ? [
    "x86_64-linux"
    "aarch64-linux"
  ],
  ...
}:
let
  eachSystem = import ./eachSystem.nix { inherit nixpkgs defaultSystems; };
in
{
  inherit (eachSystem) defaultSystems forEachSystem eachDefaultSystem;
}
