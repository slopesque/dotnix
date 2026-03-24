{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.gaming.steam;
in
{
  options = {
    my.profiles.gaming.steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Steam on the system.";
      };

      withEnhancers = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Add enhancing tools for Steam (Gamemode, Gamescope).";
      };

      withMonitoring = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Add monitoring tools for Steam (Mangohud).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      gamemode.enable = cfg.withEnhancers;

      steam = {
        enable = true;
        gamescopeSession.enable = cfg.withEnhancers;
      };
    };

    environment.systemPackages =
      with lib;
      with cfg;
      with pkgs;
      [
        (mkIf withMonitoring mangohud)
      ];
  };
}
