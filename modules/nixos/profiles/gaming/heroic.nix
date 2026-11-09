{
  config,
  lib,
  pkgs,
  ...
}@_:
let
  cfg = config.my.profiles.gaming.heroic;
in
{
  options = {
    my.profiles.gaming.heroic = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Heroic Game Launcher on the system.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ heroic ];
  };
}
