{
  nixpkgs,
  nix-on-droid,
  dotfiles,
  ...
}:
let
  system = "aarch64-linux";
in
nix-on-droid.lib.nixOnDroidConfiguration {
  pkgs = import nixpkgs { inherit system; };
  modules = [ ./nix-on-droid.nix ];
  extraSpecialArgs = { inherit dotfiles system; };
}
