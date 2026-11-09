{
  config,
  lib,
  ...
}@_:
let
  cfg = config.my.configurations;
in
{
  options = {
    my.configurations.sudo = {
      withRagebait = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "If set to true, sudo will be compiled with insults " "enabled.";
      };
    };
  };

  config = lib.mkIf cfg.sudo.withRagebait {
    nixpkgs.overlays = [
      (final: prev: {
        sudo = prev.sudo.override { withInsults = true; };
      })
    ];

    security.sudo.extraConfig = "Defaults insults";
  };
}
