{ inputs, ... }:
let
  hypryaml = inputs.hypryaml;
in
{
  nixpkgs.overlays = [
    hypryaml.overlays.default
  ];
}
