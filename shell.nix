{ pkgs, ... }:
pkgs.mkShell {
  pname = "dotnix development shell";
  packages = with pkgs; [ nixd nixfmt ];
}
