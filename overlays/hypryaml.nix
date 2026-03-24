{
  inputs,
  system,
  ...
}@_:
let
  hypryaml = inputs.hypryaml;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      hypryaml = hypryaml.packages.${system}.default;
    })
  ];
}
