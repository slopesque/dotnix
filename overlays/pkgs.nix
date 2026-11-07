{ ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        bravePkgs = prev.callPackage ../pkgs/brave/default.nix { };
      in
      {
        inherit (bravePkgs) brave brave-origin;
      }
    )
  ];
}
