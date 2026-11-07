# Based-on: https://codeberg.org/buckley310/brave-browser-nix

{ pkgs, ... }:
let
  utils = pkgs.callPackage ./utils.nix { };
  inherit (utils) mkBrave;
in
{
  brave = mkBrave ./packages/brave.nix;
  brave-origin = mkBrave ./packages/brave-origin.nix;
}
