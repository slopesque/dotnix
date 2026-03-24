{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.toolchain;
in
{
  options = {
    my.profiles.toolchain = {
      enable = lib.mkEnableOption "toolchain for Nix files (LSP, formatters...).";

      lsp.package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nixd;
        description = "Package to use as Nix LSP in text editors.";
      };

      formatter.packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
          nixfmt
          alejandra
        ];
        example = [ pkgs.nixfmt ];
        description = "Packages to use as Nix formatters in text editors.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      packages = cfg.formatter.packages ++ [ cfg.lsp.package ];
    in
    {
      environment.systemPackages = packages;
    }
  );
}
