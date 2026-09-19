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

      withSession = lib.mkEnableOption "Add Wayland session for Steam using Gamescope";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      enableGamescope = cfg.withEnhancers || cfg.withSession;
    in
    {
      programs = {
        gamescope = {
          enable = enableGamescope;
          capSysNice = cfg.withSession;
        };

        gamemode.enable = cfg.withEnhancers;

        steam = {
          enable = true;
          gamescopeSession.enable = enableGamescope;
        };
      };

      environment.systemPackages =
        with lib;
        with cfg;
        with pkgs;
        [
          (mkIf withMonitoring mangohud)
        ];
    }
  );
}
