{
  nixpkgs,
  defaultSystems ? [
    "x86_64-linux"
    "aarch64-linux"
  ],
  ...
}:
let
  inherit (nixpkgs) lib;
  forEachSystem = lib.genAttrs defaultSystems;
in
{
  inherit defaultSystems forEachSystem;
  eachDefaultSystem =
    callback:
    let
      perSystem = forEachSystem callback;
      outputParts = lib.mapAttrsToList (
        key: value: lib.mapAttrs (_: subvalue: { "${key}" = subvalue; }) value
      ) perSystem;
    in
    lib.foldr (acc: item: lib.recursiveUpdate acc item) { } outputParts;
}
