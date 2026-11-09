{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.virtualisation.docker;
in
{
  options = {
    my.profiles.virtualisation.docker = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Docker on the system.";
      };

      rootless = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Allow Docker to be run without root.";
      };

      withBuildx = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Enable Docker Buildx on the system.";
      };

      withCompose = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = true;
        description = "Enable Docker Compose on the system.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;

      rootless = lib.mkIf cfg.rootless {
        enable = true;
        setSocketVariable = true;
      };
    };

    environment.systemPackages =
      with lib;
      with cfg;
      with pkgs;
      [
        (mkIf withBuildx docker-buildx)
        (mkIf withCompose docker-compose)
      ];
  };
}
